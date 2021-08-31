//
//  UserRepositoriesTableViewViewModel.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct UserRepositoryViewModel {
    let repository: Repository
    
    init(_ repository: Repository) {
        self.repository = repository
    }
}

extension UserRepositoryViewModel {
    var name: Observable<String> {
        return Observable<String>.just(repository.name ?? "")
    }
    
    var description: Observable<String> {
        return Observable<String>.just(repository.description ?? "")
    }
    
    var license: Observable<String> {
        return Observable<String>.just(repository.license?.name ?? "")
    }
    
    var forks: Observable<String> {
        return Observable<String>.just("\(repository.forks ?? -1) Forks")
    }
}

class UserRepositoriesListViewModel {
    var userRepositoriesViewModel: [UserRepositoryViewModel]
    let hideLoading = BehaviorRelay<Bool>(value: false)

    init(_ repositories: [Repository]) {
        self.userRepositoriesViewModel = repositories.compactMap(UserRepositoryViewModel.init)
    }
}

extension UserRepositoriesListViewModel {
    func repositoryViewModel(at index: Int) -> UserRepositoryViewModel {
        return self.userRepositoriesViewModel[index]
    }
    
    func getRepositories(with login: String) -> Observable<[Repository]> {
        guard let url = URL(string: "https://api.github.com/users/\(login)/repos") else {
            fatalError("url was incorrect")
        }
                
        let resource = Resource<[Repository]>(url: url)
        
        return APIService().load(resource: resource)
    }
}
