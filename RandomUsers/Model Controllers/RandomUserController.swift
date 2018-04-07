//
//  RandomUserController.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class RandomUserController {
    
    //
    // MARK: - Shared
    //
    
    static let shared = RandomUserController()
    
    //
    // MARK: - Properties
    //
    
    let cloudKitManager: CloudKitManager
    let privateDatabase = CKContainer.default().privateCloudDatabase
    var randomUsers: [RandomUser] = [] {
        didSet {
        }
    }
    
    //
    // MARK: - Initializer
    //
    
    init() {
        self.cloudKitManager = CloudKitManager()
        fetchUsersFromCloudKit()
    }
    
    //
    // MARK: - CRUD
    //
    
    //
    // MARK: Create
    //
    
    func saveUser(user: RandomUser, completion: ((RandomUser) -> Void)?) {
        
        cloudKitManager.saveRecord(user.cloudKitRecord) { (_, error) in
            
            if let error = error {
                print("There was an error saving user to CloudKit: \(error.localizedDescription). File: \(#file). Function: \(#function)")
                return
            }
            completion?(user)
            return
        }
    }
    
    //
    // MARK: Retrieve
    //
    
    func fetchRandomUsers(completion: @escaping (_ randomUsers: [RandomUser]) -> Void) {
        
        guard let url = URL(string: "https://randomuser.me/api/?results=6") else {
            print("There was an error with the url. File: \(#file). Function: \(#function)")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("There was a fatal error: \(error.localizedDescription)")
                completion([])
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Invalid HTTP Response")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data was returned. File: \(#file). Function: \(#function)")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let randomUsers = try decoder.decode(RandomUsers.self, from: data)
                self.randomUsers = randomUsers.randomUsers
                
                for user in self.randomUsers {
                    self.saveUser(user: user, completion: { (_) in })
                }
                completion(self.randomUsers)
            } catch {
                print("\(error.localizedDescription)")
                completion([])
            }
        }
        dataTask.resume()
    }
    
    // This function will fetch an image using a URL
    func fetchImage(withUrl: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let requestURL = URL(string: withUrl) else { return }
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error { print(error.localizedDescription) }
            
            guard let data = data,
                let image = UIImage(data: data) else { completion(nil); return }
            completion(image)
        }
        dataTask.resume()
    }
    
    //
    // MARK: Delete
    //
    
    func delete(randomUser: RandomUser) {
        
        cloudKitManager.deleteRecordWithID(randomUser.recordID) { (recordID, error) in
            if let error = error {
                print("Error deleting User: \(error.localizedDescription) in file: \(#file)")
                return
            } else {
                print("Successfully deleted User")
            }
        }
    }
    
    //
    // MARK: - Fetch Users from CloudKit
    //
    
    func fetchUsersFromCloudKit() {
        
        // Retrieve all random users
        let predicate = NSPredicate(value: true)
        
        // Query
        let query = CKQuery(recordType: Keys.recordRandomUserType, predicate: predicate)
        
        // Fetch Data from CloudKit
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("There was an error while fetching Random Users data: \(error.localizedDescription). File: \(#file). Function: \(#function)")
            }
            
            guard let records = records else { return }
            
            let randomUsers = records.compactMap( {RandomUser(cloudKitRecord: $0)})
            
            self.randomUsers = randomUsers
        }
    }
    
    //
    // MARK: - Custom Functions
    //
    
    /// This function takes a string and
}
