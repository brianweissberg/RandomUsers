//
//  RandomUsers.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation
import CloudKit

struct RandomUsers: Decodable {
    
    //
    // MARK: - Properties
    //
    
    let randomUsers: [RandomUser]
    
    // Enum needed for Decodable Protocol
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    //
    // MARK: - Initializer
    //
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        randomUsers = try values.decode([RandomUser].self, forKey: .results)
    }
}
