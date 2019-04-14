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
        case .login:
            let loginViewModel = LoginViewModel()
            var viewController = LoginViewController()
            viewController.bindToViewModel(to: loginViewModel)
            return viewController
        case .playlist(let playlist, let sceneCoordinator):
            var viewController = PlaylistViewController()
            let playlistRepository = PlaylistRepository(playlistId: playlist.id)
            let viewModel = PlaylistViewModel(playlist: playlist, playlistRepository: playlistRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        }
    }
    
}
