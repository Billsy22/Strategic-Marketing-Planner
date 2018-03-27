//
//  ClientTableViewCell.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    var client: Client? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let client = client else { return }
        guard let firstName = client.firstName else { return }
        guard let lastName = client.lastName else { return }
        nameLabel.text = "\(firstName) \(lastName)"
        phoneNumberLabel.text = client.phoneNumber
        emailAddressLabel.text = client.email
    }
}
