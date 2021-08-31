//
//  UserResponse.swift
//  GetHub
//
//  Created by Hashim Ahmed on 23/01/1443 AH.
//

import Foundation

struct UserResponse: Codable {
    let login: String
    let avatarURL: String

    
    enum CodingKeys:String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
