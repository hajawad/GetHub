//
//  ForkedRepositoryUsersViewController.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import UIKit
import RxSwift
import RxCocoa

class ForkedRepositoryUsersViewController: UIViewController {
    var repositoryVM: UserRepositoryViewModel!
    var forkedUsersForRepoListVM: ForkedRepoUserListViewModel = ForkedRepoUserListViewModel([])
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var forkDescription: UILabel!
    
    @IBOutlet weak var forkedUsersTableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        forkedUsersTableView.delegate = nil
        forkedUsersTableView.dataSource = nil
        
        setupUI()
        bindUI()
        bindTableView()
    }
    
    private func setupUI() {
        forkedUsersTableView.tableFooterView = UIView()
        forkedUsersTableView.backgroundColor = UIColor.white
    }
    
    private func bindUI() {
        repositoryVM.name
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        repositoryVM.description
            .bind(to: self.repoDescription.rx.text)
            .disposed(by: disposeBag)
        
        repositoryVM.name
            .bind(to: self.repoName.rx.text)
            .disposed(by: disposeBag)
        
        repositoryVM.forks
            .bind(to: self.forkDescription.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        forkedUsersForRepoListVM.hideLoading.asDriver()
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        forkedUsersForRepoListVM.hideLoading.accept(false)
        
        let observable = forkedUsersForRepoListVM.getForkedUsers(with: repositoryVM.repository.owner!.login, repo: repositoryVM.repository.name!)
        
        observable.subscribe { forkedRepos in
//            print(forkedRepos)
        } onError: { error in
            Helpers.showAlert(title: "Error occured", message: error.localizedDescription, viewController: self)
            self.forkedUsersForRepoListVM.hideLoading.accept(true)
        } onCompleted: {
            self.forkedUsersForRepoListVM.hideLoading.accept(true)
        } onDisposed: {
            
        }.disposed(by: self.disposeBag)

        observable.asObservable()
            .bind(to: self.forkedUsersTableView.rx.items(cellIdentifier: "ForkedRepositoryUsersTableViewCell", cellType: ForkedRepositoryUsersTableViewCell.self)) {
                row, element, cell in
                            
                cell.username.text = element.owner?.login ?? ""
                cell.userAvatar?.loadImage(fromURL: element.owner?.avatarURL ?? "")

            }.disposed(by: self.disposeBag)
    }
}
