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
    
    func build() -> (vc: HomeViewController, hvm: HomeViewModel) {
        var miniPlayerView = MiniPlayerView()
        let miniPlayerViewModel = MiniPlayerViewModel(player: UIApplication.provider.player)
        miniPlayerView.bindToViewModel(to: miniPlayerViewModel)
        
        let homeViewController = HomeViewController(playerView: miniPlayerView)
        let sceneCoordinator: SceneCoordinatorType = SceneCoordinator(window: UIApplication.instance.window, viewController: homeViewController)
        let homeViewModel = HomeViewModel(userRepository: UIApplication.provider.userRepository, sceneCoordinator: sceneCoordinator)
        
        homeViewController.title = String(localizedKey: String.Key.appName)
        
        let startViewController = buildStartViewController()
        startViewController.tabBarItem.title = String(localizedKey: String.Key.tabStart)
        startViewController.tabBarItem.image = UIImage(named: "outline_home_black_24pt")
        
        let searchViewController = buildSearchViewController()
        searchViewController.tabBarItem.title = String(localizedKey: String.Key.tabCategories)
        searchViewController.tabBarItem.image = UIImage(named: "outline_view_agenda_black_24pt")
        
        homeViewController.viewControllers = [UINavigationController(rootViewController: startViewController),
                                            UINavigationController(rootViewController: searchViewController)]
        return (vc: homeViewController, hvm: homeViewModel)
    }
    
    // MARK: private
    
    private func buildStartViewController() -> UIViewController {
        var viewController = StartViewController()
        let sceneCoordinator = SceneCoordinator(window: UIApplication.instance.window, viewController: viewController)
        let startViewModel = StartViewModel(browseRepository: UIApplication.provider.browseRepository, sceneCoordinator: sceneCoordinator, player: UIApplication.provider.player)
        viewController.bindToViewModel(to: startViewModel)
        return viewController
    }
    
    private func buildSearchViewController() -> UIViewController {
        var viewController = CategoriesViewController()
        let sceneCoordinator = SceneCoordinator(window: UIApplication.instance.window, viewController: viewController)
        let searchViewModel = CategoriesViewModel(browseRepository: UIApplication.provider.browseRepository, sceneCoordinator: sceneCoordinator, player: UIApplication.provider.player)
        viewController.bindToViewModel(to: searchViewModel)
        return viewController
    }
    
}
