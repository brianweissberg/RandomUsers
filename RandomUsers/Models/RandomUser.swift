//
//  RandomUser.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation
import CloudKit

struct RandomUser: Decodable {
    
    //
    // MARK: - Properties
    //
    
    let email: String
    let phone: String
    let firstName: String
    let lastName: String
    let street: String
    let city: String
    let state: String
    let postcode: String
    let thumbnail: String
    let recordID: CKRecordID
    
    // Enums needed for Decodable Protocol
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        case location
    }
    
    enum NameKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }
    
    enum LocationKeys: String, CodingKey {
        case street
        case city
        case state
        case postcode
    }
    
    enum ImageKeys: String, CodingKey {
        case thumbnail
    }
    
    //
    // MARK: - Initializer
    //
    
    init(from decoder: Decoder) throws {
        
        // Top level JSON Values
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        
        // Nested Name Values
        let name = try values.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        firstName = try name.decode(String.self, forKey: .firstName)
        lastName = try name.decode(String.self, forKey: .lastName)
        
        // Nested Address Values
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        street = try location.decode(String.self, forKey: .street)
        city = try location.decode(String.self, forKey: .city)
        state = try location.decode(String.self, forKey: .state)
        
        do {
            postcode = try location.decode(String.self, forKey: .postcode)
        } catch DecodingError.typeMismatch {
            let postcodeDouble = try location.decode(Double.self, forKey: .postcode)
            postcode = "\(postcodeDouble)"
        }
        
        // Nested Image Data
        let image = try values.nestedContainer(keyedBy: ImageKeys.self, forKey: .picture)
        thumbnail = try image.decode(String.self, forKey: .thumbnail)
        
        // Create a CloudKit Record ID upon initialization
        recordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    //
    // MARK: - CloudKit Properties
    //
    
    // PUT: CloudKit Record
    var cloudKitRecord: CKRecord {
        
        let record = CKRecord(recordType: Keys.recordRandomUserType, recordID: recordID)
        
        record.setValue(email, forKey: Keys.emailKey)
        record.setValue(phone, forKey: Keys.phoneKey)
        record.setValue(firstName, forKey: Keys.firstNameKey)
        record.setValue(lastName, forKey: Keys.lastNameKey)
        record.setValue(street, forKey: Keys.streetKey)
        record.setValue(city, forKey: Keys.cityKey)
        record.setValue(state, forKey: Keys.stateKey)
        record.setValue(postcode, forKey: Keys.postcodeKey)
        record.setValue(thumbnail, forKey: Keys.thumbnailKey)
        
        return record
    }
    
    // Failable Initializer Cloudkit
    init?(cloudKitRecord: CKRecord) {
        
        guard let email = cloudKitRecord[Keys.emailKey] as? String,
        let phone = cloudKitRecord[Keys.phoneKey] as? String,
        let firstName = cloudKitRecord[Keys.firstNameKey] as? String,
        let lastName = cloudKitRecord[Keys.lastNameKey] as? String,
        let street = cloudKitRecord[Keys.streetKey] as? String,
        let city = cloudKitRecord[Keys.cityKey] as? String,
        let state = cloudKitRecord[Keys.stateKey] as? String,
        let postcode = cloudKitRecord[Keys.postcodeKey] as? String,
            let thumbnail = cloudKitRecord[Keys.thumbnailKey] as? String else { return nil }
        
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.street = street
        self.city = city
        self.state = state
        self.postcode = postcode
        self.thumbnail = thumbnail
        self.recordID = cloudKitRecord.recordID
    }
}
