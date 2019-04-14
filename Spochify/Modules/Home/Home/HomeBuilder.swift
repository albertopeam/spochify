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
        var homeViewController = HomeViewController()
        let userRepository = UserRepository(network: Network(urlSession: URLSession.shared, storage: Storage()))
        let sceneCoordinator: SceneCoordinatorType = SceneCoordinator(window: UIApplication.instance.window, viewController: homeViewController)
        let homeViewModel = HomeViewModel(userRepository: userRepository, sceneCoordinator: sceneCoordinator)
        homeViewController.bindToViewModel(to: homeViewModel)
        
        let tabBarController = homeViewController
        tabBarController.title = String(localizedKey: String.Key.appName)
        
        let startViewController = buildStartViewController()
        startViewController.tabBarItem.title = String(localizedKey: String.Key.tabStart)
        startViewController.tabBarItem.image = UIImage(named: "baseline_home_black_24pt")
        
        let searchViewController = buildSearchViewController()
        searchViewController.tabBarItem.title = String(localizedKey: String.Key.tabSearch)
        searchViewController.tabBarItem.image = UIImage(named: "baseline_search_black_24pt")
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: startViewController),
                                            UINavigationController(rootViewController: searchViewController)]
        return tabBarController
    }
    
    // MARK: private
    
    private func buildStartViewController() -> UIViewController {
        var viewController = StartViewController()
        let sceneCoordinator = SceneCoordinator(window: UIApplication.instance.window, viewController: viewController)
        let browseRepository = BrowseRepository(network: Network(urlSession: URLSession.shared, storage: Storage()))
        let startViewModel = StartViewModel(browseRepository: browseRepository, sceneCoordinator: sceneCoordinator)
        viewController.bindToViewModel(to: startViewModel)
        return viewController
    }
    
    private func buildSearchViewController() -> UIViewController {
        return SearchViewController()
    }
    
}
