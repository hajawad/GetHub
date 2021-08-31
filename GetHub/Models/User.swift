//
//  User.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarURL: String
    let numOfRepos: Int
    let numOfFollowers: Int
    let reposURL: String
    
    enum CodingKeys:String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case numOfRepos = "public_repos"
        case numOfFollowers = "followers"
        case reposURL = "repos_url"
    }
    
    init() {
        login = ""
        avatarURL = ""
        numOfRepos = 0
        numOfFollowers = 0
        reposURL = ""
    }
}
