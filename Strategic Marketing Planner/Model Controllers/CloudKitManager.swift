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
    
    private init(){
        if UserDefaults.standard.clientRecordZone == nil {
            setupRecordZone(withName: clientZoneName)
        }else{
            zoneID = UserDefaults.standard.clientRecordZone
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
                completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), error)
            }else if let cursor = cursor {
                self?.database.add(CKQueryOperation(cursor: cursor))
            }else{
                completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), nil)
            }
        }
        database.add(operation)
    }
    
//    func getDatabaseChanges(){
//        let changesOperation = CKFetchDatabaseChangesOperation(previousServerChangeToken: UserDefaults.standard.serverChangeToken)
//        var changeZoneIDs: [CKRecordZoneID] = []
//        changesOperation.recordZoneWithIDChangedBlock = { (zoneId) in
//            changeZoneIDs.append(zoneId)
//        }
//
//        changesOperation.changeTokenUpdatedBlock = { (token) in
//            UserDefaults.standard.serverChangeToken = token
//        }
//
//        changesOperation.fetchAllChanges = true
//
//        changesOperation.fetchDatabaseChangesCompletionBlock = {
//            (token, moreComing, error) in
//
//            if let error = error {
//                NSLog("Error during fetch database changes operation: \(error.localizedDescription)")
//            }
//
//
//        }
//
//        changesOperation.qualityOfService = .userInitiated
//
//        database.add(changesOperation)
//    }
    
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
        
        operation.recordWithIDWasDeletedBlock = { (recordId, recordType) in
            if recordType == Client.recordType {
                if let client = ClientController.shared.clients.first(where: {$0.recordName == recordId.recordName}){
                    ClientController.shared.removeClient(client)
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
    
    
    func updateEntity<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        guard let record = entity.asCKRecord else {
            completion(false)
            return
        }
        let modOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
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
    
//    func subscribeToRecordDeletedNotifications<T: CloudKitSynchable>(_ type: T.Type){
//        let desiredKeys = ["recordName"]
//        let notificationInfo = CKNotificationInfo()
//        notificationInfo.alertBody = nil
//        notificationInfo.shouldBadge = false
//        notificationInfo.shouldSendContentAvailable = true
//        notificationInfo.desiredKeys = desiredKeys
//        let predicate = NSPredicate(value: true)
//        let subscription = CKQuerySubscription(recordType: T.recordType, predicate: predicate, options: [.firesOnRecordDeletion])
//        subscription.notificationInfo = notificationInfo
//        database.save(subscription) { (subscription, error) in
//            if let error = error {
//                NSLog("Subscription error.  Failed to create new subscription for deletions: \(error.localizedDescription)")
//            }
//        }
//    }
}
