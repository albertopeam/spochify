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
            let loginViewModel = LoginViewModel(userRepository: UIApplication.instance.userRepository, sceneCoordinator: sceneCoordinator)
            var viewController = LoginViewController()
            viewController.bindToViewModel(to: loginViewModel)
            return viewController
        case .playlist(let playlist, let sceneCoordinator):
            var viewController = PlaylistViewController()
            let playlistRepository = PlaylistRepository(network: UIApplication.instance.network, storage: UIApplication.instance.storage, playlistId: playlist.id)
            let viewModel = PlaylistViewModel(playlist: playlist, playlistRepository: playlistRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        }
    }
    
}
