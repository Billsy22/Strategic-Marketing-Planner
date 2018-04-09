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
    
    static func loadEntities<T: CloudKitSynchable>(ofType: T.Type, exclude: [CKRecord], completion: @escaping ([T]?, Error?) -> Void){
        
    }
    
    static func saveEntity<T: CloudKitSynchable>(entity: T, completion: @escaping (Bool) -> Void){
        let record = entity.asCKRecord
//        database.save(record) { (record, error) in
//            <#code#>
//        }
        
    }
    
    
}
