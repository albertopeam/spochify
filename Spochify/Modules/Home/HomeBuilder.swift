//
//  HomeBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeBuilder {
    
    func build() -> UIViewController {
        let userRepository = UserRepository(network: Network(storage: Storage()), urlSession: URLSession.shared)
        let homeViewModel = HomeViewModel(userRepository: userRepository, sceneCoordinator: UIApplication.instance.sceneCoordinator)
        var homeViewController = HomeViewController()
        homeViewController.bindViewModel(to: homeViewModel)
        let tabBarController = homeViewController
        tabBarController.title = String(localizedKey: String.Key.appName)
        let startViewController = StartBuilder().build()
        startViewController.tabBarItem.title = String(localizedKey: String.Key.tabStart)
        startViewController.tabBarItem.image = UIImage(named: "baseline_home_black_24pt")
        let searchViewController = SearchBuilder().build()
        searchViewController.tabBarItem.title = String(localizedKey: String.Key.tabSearch)
        searchViewController.tabBarItem.image = UIImage(named: "baseline_search_black_24pt")
        tabBarController.viewControllers = [startViewController, searchViewController]
        return tabBarController
    }
    
}

class HomeViewController: UITabBarController, BindableType {
    
    typealias ViewModelType = HomeViewModel
    var viewModel: HomeViewModel!
    
    func bindViewModel() {
        viewModel.binded()
    }

}

class HomeViewModel {
    
    private let userRepository: UserRepository
    private let sceneCoordinator: SceneCoordinatorType
    //TODO: forward vc bag...?
    private var disposeBag = DisposeBag()
    
    lazy var isAuth: Observable<Bool> = userRepository.user.map { (user) -> Bool in
        return true
    }
    
    init(userRepository: UserRepository, sceneCoordinator: SceneCoordinatorType) {
        self.userRepository = userRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    func binded() {
        userRepository
            .isNotAuthenticated
            //TODO: intercept, open next scene with params, if respond ok, dismiss
            //TODO: aún no se como hacerlo
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                self.sceneCoordinator.transition(to: Scene.login, type: SceneTransitionType.modal)
                //TODO: chola el dismiss
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//                    self.sceneCoordinator.pop()
//                })
            })
            .disposed(by: disposeBag)
    }
    
}
