//
//  Globals.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation

class Globals {
    
    //
    // MARK: - Shared
    //
    
    static let shared = Globals()
    
    /// This function takes in a string and capitalizes all of the words in the string
    func returnCapitalizedString(string: String) -> String {
        let array = string.components(separatedBy: " ")
        let capitalizedStrings = array.map { $0.capitalized }
        let formattedString = capitalizedStrings.joined(separator: " ")
        return formattedString
    }
    
    /// This function is designed to take a string of number and characters and return it in the following domestic format: (123) 456-7890
    func formatPhoneNumberFrom(string: String) -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: "1234567890")
        let stringOfInts = string.components(separatedBy: allowedCharacterSet.inverted).joined()
        let count = stringOfInts.count
        
        switch count {
        case 10:
            let stringComponents = Array(stringOfInts)
            let areaCode = String(stringComponents.prefix(3))
            let prefix = String(stringComponents[3...5])
            let lineNumber = String(stringComponents.suffix(4))
            return "(\(areaCode)) \(prefix)-\(lineNumber)"
        case 7:
            let stringComponents = Array(stringOfInts)
            let prefix = String(stringComponents.prefix(3))
            let lineNumber = String(stringComponents.suffix(4))
            return "\(prefix)-\(lineNumber)"
        default:
            return stringOfInts
        }
    }
}
