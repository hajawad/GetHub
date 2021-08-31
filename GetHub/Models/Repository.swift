//
//  Repository.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation

struct License: Codable {
    let name: String?
}

struct Repository: Codable {
    let name: String?
    let description: String?
    let forks: Int?
    let license: License?
    let owner: UserResponse?
}
