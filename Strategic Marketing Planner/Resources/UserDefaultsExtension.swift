//
//  CKTokenSaver.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/11/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CloudKit

public extension UserDefaults {
    
    private var changeTokenKey: String {
        return "ChangeToken"
    }
    private var recordZoneKey: String {
        return "ClientRecordZone"
    }
    private var clientZoneCreatedKey: String {
        return "ClientZoneID"
    }
    
    public var serverChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: changeTokenKey) as? Data else { return nil }
            
            guard let token = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken else { return nil }
            
            return token
        }
        
        set {
            if let token = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: token)
                set(data, forKey: changeTokenKey)
            }else{
                removeObject(forKey: changeTokenKey)
            }
        }
    }
    
    public var clientRecordZone: CKRecordZoneID? {
        get {
            guard let data = self.value(forKey: recordZoneKey) as? Data else { return nil }
            
            guard let zoneID = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKRecordZoneID else { return nil }
            
            return zoneID
        }
        
        set {
            if let recordID = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: recordID)
                set(data, forKey: recordZoneKey)
            }else{
                removeObject(forKey: recordZoneKey)
            }
        }
    }
    
    public var clientZoneCreated: Bool {
        get {
            if let value = self.value(forKey: clientZoneCreatedKey) as? Bool {
                return value
            }else{
                return false
            }
        }
        
        set {
            set(newValue, forKey: clientZoneCreatedKey)
        }
    }
    
}
