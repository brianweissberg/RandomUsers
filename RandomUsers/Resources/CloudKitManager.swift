//
//  CloudKitManager.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    //
    // MARK: - CloudKit Database
    //
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    //
    // MARK: - Save
    //
    
    func saveRecord(_ record: CKRecord, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        privateDataBase.save(record, completionHandler: { (record, error) in
            completion?(record, error)
        })
    }
    
    //
    // MARK: - Delete
    //
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        privateDataBase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    //
    // MARK: - User Sign In Verification
    //
    
    func checkIfUserIsSignedIntoCloudKit() -> Bool {
        
        if FileManager.default.ubiquityIdentityToken != nil {
            print("iCloud Signed In")
            return true
        }
        return false
    }
}
