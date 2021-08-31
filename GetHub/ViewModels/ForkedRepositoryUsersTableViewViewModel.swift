//
//  ForkedRepositoryUsersTableViewViewModel.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation
import RxSwift
import RxCocoa

struct ForkedRepoUserViewModel {
    let user: UserResponse
    
    init(_ user: UserResponse) {
        self.user = user
    }
}

extension ForkedRepoUserViewModel {
    var login: Observable<String> {
        return Observable<String>.just(user.login)
    }
    
    var avatarURL: String {
        return user.avatarURL
    }
}

class ForkedRepoUserListViewModel {
    var forkedRepoUsersViewModel: [ForkedRepoUserViewModel]
    let hideLoading = BehaviorRelay<Bool>(value: false)

    init(_ users: [UserResponse]) {
        self.forkedRepoUsersViewModel = users.compactMap(ForkedRepoUserViewModel.init)
    }
}

extension ForkedRepoUserListViewModel {
    func userViewModel(at index: Int) -> ForkedRepoUserViewModel {
        return self.forkedRepoUsersViewModel[index]
    }
    
    func getForkedUsers(with login: String, repo: String) -> Observable<[Repository]> {
        guard let url = URL(string: "https://api.github.com/repos/\(login)/\(repo)/forks") else {
            fatalError("url was incorrect")
        }
                
        let resource = Resource<[Repository]>(url: url)
        
        return APIService().load(resource: resource)
    }
}
