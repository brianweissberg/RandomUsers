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
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        phoneLabel.text = user.phone
        streetLabel.text = user.street
        cityStateZipLabel.text = "\(user.city), \(user.state) \(user.postcode)"
        emailLabel.text = user.email
        
        RandomUserController.shared.fetchImage(withUrl: user.thumbnail) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }
        }
    }
}
