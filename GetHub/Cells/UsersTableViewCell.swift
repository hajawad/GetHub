//
//  UsersTableViewCell.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var numOfRepos: UILabel!
    @IBOutlet weak var numOfFollowers: UILabel!
    
    override func prepareForReuse() {
        userAvatar.image = UIImage()
    }
}
