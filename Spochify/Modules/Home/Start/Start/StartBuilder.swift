//
//  StartBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController

class StartBuilder {
    
    func build() -> UIViewController {
        var viewController = StartViewController()
        let sceneCoordinator = SceneCoordinator(window: UIApplication.instance.window, viewController: viewController)
        let browseRepository = BrowseRepository(network: Network(urlSession: URLSession.shared, storage: Storage()))
        let startViewModel = StartViewModel(browseRepository: browseRepository, sceneCoordinator: sceneCoordinator)
        viewController.bindToViewModel(to: startViewModel)
        return viewController
    }
    
}
