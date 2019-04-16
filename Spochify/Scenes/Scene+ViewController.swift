//
//  SearchBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension Scene {
    
    func viewController() -> UIViewController {
        switch self {
        case .login(let sceneCoordinator):
            let loginViewModel = LoginViewModel(userRepository: UIApplication.provider.userRepository, sceneCoordinator: sceneCoordinator)
            var viewController = LoginViewController()
            viewController.bindToViewModel(to: loginViewModel)
            return viewController
        case .playlist(let playlist, let sceneCoordinator):
            var viewController = PlaylistViewController()
            let viewModel = PlaylistViewModel(playlist: playlist, playlistRepository: UIApplication.provider.playlistRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        case .categoryPlaylists(let category, let sceneCoordinator):
            let viewModel = CategoryPlaylistsViewModel(category: category, browseRepository: UIApplication.provider.browseRepository, sceneCoordinator: sceneCoordinator)
            var viewController = CategoryPlaylistsViewController()
            viewController.bindToViewModel(to: viewModel)
            return viewController
        }
    }
    
}
