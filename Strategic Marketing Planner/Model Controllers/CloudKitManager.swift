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
    
    private static let database = CKContainer.default().privateCloudDatabase
    //Prevent anyone from making an instance of this class, as it is meant to be used statically.
    private init(){}
    
    static func loadEntities<T: CloudKitSynchable>(ofType type: T.Type, exclude: [CKRecord], completion: @escaping ([T]?, Error?) -> Void){
        var fetchedRecords: [CKRecord] = []
        let predicate = NSPredicate(format: "NOT(recordName IN %@)", argumentArray: [exclude.map({$0.recordID})])
        let query = CKQuery(recordType: type.recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordFetchedBlock = {
            (record) in
            fetchedRecords.append(record)
        }
        operation.queryCompletionBlock = {
            (cursor, error) in
            if let error = error {
                NSLog("Error fetching records: \(error.localizedDescription)")
                completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), error)
            }else if let cursor = cursor {
                database.add(CKQueryOperation(cursor: cursor))
            }else{
                completion(fetchedRecords.compactMap({T.updateModel(from: $0, in: CoreDataStack.context)}), nil)
            }
        }
        database.add(operation)
    }
    
    static func saveEntity<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        let record = entity.asCKRecord
        database.save(record) { (_, error) in
            if let error = error {
                NSLog("Error saving record: \(error.localizedDescription)")
                completion(false)
            }else{
                NSLog("Record saved succesfully")
            }
        }
    }
    
    static func updateEntity<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        let modOperation = CKModifyRecordsOperation(recordsToSave: [entity.asCKRecord], recordIDsToDelete: nil)
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
    
    static func delete<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        let record = entity.asCKRecord
        database.delete(withRecordID: record.recordID) { (recordID, error) in
            if let error = error {
                NSLog("Failed to delete record: \(error)")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    static func subscribeNewRecordsAndUpdates<T: CloudKitSynchable>(_ type: T.Type){
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = nil
        notificationInfo.shouldBadge = false
        notificationInfo.shouldSendContentAvailable = true
        let predicate = NSPredicate(value: true)
        let options: CKQuerySubscriptionOptions
        if T.recordType == Client.recordType {
            options = [.firesOnRecordCreation, .firesOnRecordUpdate]
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
    
    static func subscribeToRecordDeletedNotifications<T: CloudKitSynchable>(_ type: T.Type){
        let desiredKeys = ["recordName"]
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = nil
        notificationInfo.shouldBadge = false
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.desiredKeys = desiredKeys
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: T.recordType, predicate: predicate, options: [.firesOnRecordDeletion])
        subscription.notificationInfo = notificationInfo
        database.save(subscription) { (subscription, error) in
            if let error = error {
                NSLog("Subscription error.  Failed to create new subscription for deletions: \(error.localizedDescription)")
            }
        }
    }
}
