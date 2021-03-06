//
//  MainTableViewCell.swift
//  RandomUsers
//
//  Created by Brian Weissberg on 4/7/18.
//  Copyright © 2018 Brian Weissberg. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewCell: UITableViewCell {
    
    //
    // MARK: - Properties
    //
    
    var user: RandomUser? {
        didSet {
            DispatchQueue.main.async {
                self.updateCell()
            }
        }
    }
    
    //
    // MARK: - Outlets
    //
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    //
    // MARK: - Methods
    //
    
    func updateCell() {
        
        guard let user = user else { return }
        
        // Update TableView Cell Labels
        nameLabel.text = "\(user.firstName.capitalized) \(user.lastName.capitalized)"
        phoneLabel.text = "\(Globals.shared.formatPhoneNumberFrom(string: user.phone))"
        streetLabel.text = Globals.shared.returnCapitalizedString(string: user.street)
        cityStateZipLabel.text = "\(user.city.capitalized), \(user.state.capitalized) \(Globals.shared.formatZipCodeFrom(string: user.postcode))"
        emailLabel.text = user.email
        
        // Update TableView Cell Images
        RandomUserController.shared.fetchImage(withUrl: user.thumbnail) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.size.width / 2
                    self.thumbnailImageView.layer.masksToBounds = true
                    self.thumbnailImageView.image = image
                }
            }
        }
    }
}
