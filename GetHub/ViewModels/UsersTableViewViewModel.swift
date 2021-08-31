//
//  UsersTableViewViewModel.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct UserViewModel {
    let user: User
    
    init(_ user: User) {
        self.user = user
    }
}

extension UserViewModel {
    var login: Observable<String> {
        return Observable<String>.just(user.login)
    }
    
    var numOfRepos: Observable<String> {
        return Observable<String>.just("\(user.numOfRepos) Repos")
    }
    
    var numOfFollowers: Observable<String> {
        return Observable<String>.just("\(user.numOfFollowers) Followers")
    }
    
    var avatarURL: String {
        return user.avatarURL
    }
}

class UsersListViewModel {
    var usersViewModel: [UserViewModel]
    let hideLoading = BehaviorRelay<Bool>(value: false)

    init(_ users: [User]) {
        self.usersViewModel = users.compactMap(UserViewModel.init)
    }
}

extension UsersListViewModel {
    func userViewModel(at index: Int) -> UserViewModel {
        return self.usersViewModel[index]
    }
    
    func getUser(with login: String) -> Observable<User> {
        guard let url = URL(string: "https://api.github.com/users/\(login)") else {
            fatalError("url was incorrect")
        }
                
        let resource = Resource<User>(url: url)
        
        return APIService().load(resource: resource)
    }
    
    func getUsers(completionHandler: @escaping ([UserResponse]) -> Void) {
        guard let url = URL(string: "https://api.github.com/users") else {            fatalError("url was incorrect")
        }

        let resource = Resource<[UserResponse]>(url: url)
        APIService().load(resource: resource, completionHandler: { result in
            completionHandler(result)
        })
    }
}
