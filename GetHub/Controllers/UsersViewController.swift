//
//  UsersTableViewController.swift
//  GetHub
//
//  Created by Hashim Ahmed on 21/01/1443 AH.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var usersListViewModel: UsersListViewModel = UsersListViewModel([])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.delegate = nil
        usersTableView.dataSource = nil
        
        setupUI()
        bindUI()
        bindTableView()
        bindTableViewSelected()
    }
    
    private func setupUI() {
        usersTableView.backgroundColor = UIColor.white
        usersTableView.tableFooterView = UIView()
    }
    
    private func bindUI() {
        usersListViewModel.hideLoading.asDriver()
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        usersListViewModel.hideLoading.accept(false)

        usersListViewModel.getUsers { userResponses in
            DispatchQueue.main.async {
                let observable = Observable
                    .zip(userResponses.map{self.usersListViewModel.getUser(with: $0.login)})
                
                observable.subscribe { repositories in
        //            print("On next")
        //            print(repositories)
                } onError: { error in
        //            print("On error")
                    Helpers.showAlert(title: "Error occured", message: error.localizedDescription, viewController: self)
                    self.usersListViewModel.hideLoading.accept(true)
                } onCompleted: {
                    self.usersListViewModel.hideLoading.accept(true)
                } onDisposed: {
        //            print("On disposed")
                }.disposed(by: self.disposeBag)
                
                observable
                    .asObservable()
                    .bind(to: self.usersTableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { row, element, cell in
                    self.usersListViewModel.hideLoading.accept(true)

                    cell.userAvatar?.loadImage(fromURL: element.avatarURL)
                    cell.username?.text = element.login
                    cell.numOfFollowers?.text = "\(element.numOfFollowers) Followers"
                    cell.numOfRepos?.text = "\(element.numOfRepos) Repos"
                    }
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
    private func bindTableViewSelected() {
        self.usersTableView
            .rx
            .modelSelected(User.self)
            .subscribe(onNext :{ [weak self] user in
                
                guard let strongSelf = self else { return }
                
                guard let userReposVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "UserRepositoresViewController") as? UserRepositoresViewController else {
                    fatalError("TaskDetailsViewController not found")
                }

                userReposVC.userVM = UserViewModel.init(user)
                
                strongSelf.navigationController?.pushViewController(userReposVC, animated: true)
                
            })
            .disposed(by: disposeBag)
    }
}
