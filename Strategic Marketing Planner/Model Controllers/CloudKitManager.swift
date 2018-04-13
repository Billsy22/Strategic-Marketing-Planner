//
//  CloudKitManager.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/9/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    private let database = CKContainer.default().privateCloudDatabase
    private let clientZoneName: String = "client_zone"
    private var zoneID: CKRecordZoneID?
    
    static let shared = CloudKitManager()
    
    enum Notifications {
        static let NoAccountNotification = NSNotification.Name("NoAccountLoggedIn")
        static let AccountInfoUnavailable = NSNotification.Name("CloudStatusUnavailable")
        static let AccountRestricted = NSNotification.Name("NoAccessAccountRestricted")
    }
    
    private init(){
        if UserDefaults.standard.clientRecordZone == nil {
            setupRecordZone(withName: clientZoneName)
        }else{
            zoneID = UserDefaults.standard.clientRecordZone
        }
        CKContainer.default().accountStatus { (accountStatus, error) in
            if let error = error {
                NSLog("Error determining iCloud account status: \(error.localizedDescription)")
            }
            switch accountStatus {
            case .available:
                NSLog("iCloud status OK")
            case .noAccount:
                NotificationCenter.default.post(name: Notifications.NoAccountNotification, object: nil)
            case .couldNotDetermine:
                NotificationCenter.default.post(name: Notifications.AccountInfoUnavailable, object: nil)
            case.restricted:
                NotificationCenter.default.post(name: Notifications.AccountRestricted, object: nil)
            }
        }
    }
    
    private func setupRecordZone(withName name: String){
        let recordZone = CKRecordZone(zoneName: name)
        database.save(recordZone) {[weak self] (recordZone, error) in
            if let error = error {
                NSLog("Error saving record zone: \(error.localizedDescription)")
            }else{
                UserDefaults.standard.clientRecordZone = recordZone?.zoneID
                self?.zoneID = recordZone?.zoneID
            }
        }
    }
    
    func loadEntities<T: CloudKitSynchable>(ofType type: T.Type, exclude: [CKRecord], completion: @escaping ([T]?, Error?) -> Void){
        var fetchedRecords: [CKRecord] = []
        let predicate = NSPredicate(format: "NOT(recordName IN %@)", argumentArray: [exclude.map({$0.recordID})])
        let query = CKQuery(recordType: type.recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.zoneID = zoneID
        operation.recordFetchedBlock = {
            (record) in
            fetchedRecords.append(record)
        }
        operation.queryCompletionBlock = {[weak self]
            (cursor, error) in
            if let error = error {
                NSLog("Error fetching records: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), error)
                }
            }else if let cursor = cursor {
                self?.database.add(CKQueryOperation(cursor: cursor))
            }else{
                DispatchQueue.main.async {
                    completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), nil)
                }
            }
        }
        database.add(operation)
    }
    
    func fetchChanges(completion: @escaping (_ success: Bool) -> Void){
        var optionsByRecordZoneID: [CKRecordZoneID: CKFetchRecordZoneChangesOptions] = [:]
        let options = CKFetchRecordZoneChangesOptions()
        options.previousServerChangeToken = UserDefaults.standard.serverChangeToken
        guard let zoneID = zoneID else {
            completion(false)
            return
        }
        optionsByRecordZoneID[zoneID] = options
        
        let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [zoneID], optionsByRecordZoneID: optionsByRecordZoneID)
        
        operation.recordChangedBlock = { (record) in
            let recordType = record.recordType
            DispatchQueue.main.async {
                switch recordType {
                case Client.recordType:
                    _ = Client.updateModel(from: record, in: CoreDataStack.context)
                case MarketingPlan.recordType:
                    _ = MarketingPlan.updateModel(from: record, in: CoreDataStack.context)
                case MarketingOption.recordType:
                    _ = MarketingOption.updateModel(from: record, in: CoreDataStack.context)
                default:
                    NSLog("BIG PROBLEM: Encountered an unknown record type.")
                }
            }
        }
        
        operation.recordWithIDWasDeletedBlock = { (recordId, recordType) in
            if recordType == Client.recordType {
                //TODO: - Refactor this so that there are background an main thread contexts to make things thread safe.  Right now clients cannot be safely accessed outside of the main thread.
                DispatchQueue.main.async {
                    if let client = ClientController.shared.clients.first(where: {$0.recordName == recordId.recordName}){
                        ClientController.shared.removeClient(client)
                    }
                }
            }
        }
        
        operation.recordZoneFetchCompletionBlock = {zoneID, token, _, _, error in
            if let error = error {
                NSLog("Error fetching zone changes for \(zoneID.zoneName): \(error.localizedDescription)")
            }
            UserDefaults.standard.serverChangeToken = token
        }
        
        operation.fetchRecordZoneChangesCompletionBlock = { (error) in
            if let error = error {
                NSLog("Error fetching zone changes. \(error.localizedDescription)")
                completion(false)
            }else{
                completion(true)
            }
        }
        
        operation.qualityOfService = .userInitiated
        
        database.add(operation)
    }
    
    
    func updateEntity<T: CloudKitSynchable>(entities: [T], completion: @escaping (Bool) -> Void){
        let records: [CKRecord] = entities.compactMap({$0.asCKRecord})
        let modOperation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        modOperation.savePolicy = .allKeys
        modOperation.perRecordCompletionBlock = {
            (_, error) in
            if let error = error {
                NSLog("Failed to update record: \(error.localizedDescription)")
                completion(false)
            }else{
                completion(true)
            }
        }
        database.add(modOperation)
    }
    
    func delete<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        guard let record = entity.asCKRecord else {
            completion(false)
            return
        }
        database.delete(withRecordID: record.recordID) { (recordID, error) in
            if let error = error {
                NSLog("Failed to delete record: \(error)")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func subscribeToChanges<T: CloudKitSynchable>(_ type: T.Type){
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = nil
        notificationInfo.shouldBadge = false
        notificationInfo.shouldSendContentAvailable = true
        let predicate = NSPredicate(value: true)
        let options: CKQuerySubscriptionOptions
        if T.recordType == Client.recordType {
            options = [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion]
        }else{
            options = [.firesOnRecordUpdate]
        }
        
        let subscription = CKQuerySubscription(recordType: T.recordType, predicate: predicate, subscriptionID: T.recordType, options: options)
        subscription.notificationInfo = notificationInfo
        database.save(subscription) { (subscription, error) in
            if let error = error {
                NSLog("Subscription error.  Failed to create new subscription: \(error.localizedDescription)")
            }
        }
    }
}
