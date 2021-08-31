//
//  ForkedRepositoryUsersTableViewCell.swift
//  GetHub
//
//  Created by Hashim Ahmed on 23/01/1443 AH.
//

import UIKit

class ForkedRepositoryUsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func prepareForReuse() {
        userAvatar.image = UIImage()
    }
}
