//
//  UserRepositoriesTableViewController.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import UIKit
import RxSwift
import RxCocoa

class UserRepositoresViewController: UIViewController {
    var userVM: UserViewModel!
    var userRepositoryListVM: UserRepositoriesListViewModel = UserRepositoriesListViewModel([])
    let disposeBag = DisposeBag()

    @IBOutlet weak var repositoriesTableView: UITableView!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numOfFollowersLabel: UILabel!
    @IBOutlet weak var numOfReposLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        repositoriesTableView.delegate = nil
        repositoriesTableView.dataSource = nil
        
        setupUI()
        bindUI()
        bindTableView()
        bindTableViewSelected()
    }
    
    private func setupUI() {
        repositoriesTableView.tableFooterView = UIView()
        repositoriesTableView.backgroundColor = UIColor.white
    }
    
    private func bindUI() {
        userVM.login
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        userAvatarImageView.loadImage(fromURL: userVM.avatarURL)
        
        userVM.login
            .bind(to: self.usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        userVM.numOfFollowers
            .asObservable()
            .bind(to: self.numOfFollowersLabel.rx.text)
            .disposed(by: disposeBag)
        
        userVM.numOfRepos
            .bind(to: self.numOfReposLabel.rx.text)
            .disposed(by: disposeBag)
        
        userRepositoryListVM.hideLoading.asDriver()
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        userRepositoryListVM.hideLoading.accept(false)
        
        let observable = userRepositoryListVM.getRepositories(with: userVM.user.login)
        
        observable.subscribe { repositories in
//            print("On next")
//            print(repositories)
        } onError: { error in
//            print("On error")
            Helpers.showAlert(title: "Error occured", message: error.localizedDescription, viewController: self)
            self.userRepositoryListVM.hideLoading.accept(true)
        } onCompleted: {
//            print("On completed")
            self.userRepositoryListVM.hideLoading.accept(true)
        } onDisposed: {
//            print("On disposed")
        }.disposed(by: self.disposeBag)
        
        observable
            .asObservable()
            .bind(to: self.repositoriesTableView.rx.items(cellIdentifier: "UserRepositoresTableViewCell", cellType: UserRepositoresTableViewCell.self)) {
                row, element, cell in
                self.userRepositoryListVM.hideLoading.accept(true)

                cell.repoName.text = element.name ?? ""
                cell.repoDescription.text = element.description ?? ""
                cell.numOfForks.text = "\(element.forks ?? -1) Forks"
                cell.licenseLabel.text = element.license?.name ?? "No License"
                
            }.disposed(by: self.disposeBag)
    }
    
    private func bindTableViewSelected() {
        self.repositoriesTableView
            .rx
            .modelSelected(Repository.self)
            .subscribe(onNext :{ [weak self] repository in

                guard let strongSelf = self else { return }

                guard let forkedRepoUsersVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "ForkedRepositoryUsersViewController") as? ForkedRepositoryUsersViewController else {
                    fatalError("ForkedRepositoryUsersViewController not found")
                }

                forkedRepoUsersVC.repositoryVM = UserRepositoryViewModel.init(repository)

                strongSelf.navigationController?.pushViewController(forkedRepoUsersVC, animated: true)

            })
            .disposed(by: disposeBag)
    }
}
