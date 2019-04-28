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
            let playlistRepository = PlaylistRepository(playlist: playlist, network: UIApplication.provider.network, storage: UIApplication.provider.storage)
            let viewModel = PlaylistViewModel(playlistRepository: playlistRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        case .categoryPlaylists(let category, let sceneCoordinator):
            let viewModel = CategoryPlaylistsViewModel(category: category, browseRepository: UIApplication.provider.browseRepository, sceneCoordinator: sceneCoordinator)
            var viewController = CategoryPlaylistsViewController()
            viewController.bindToViewModel(to: viewModel)
            return viewController
        case .player(let title, let tracks, let sceneCoordinator):
            var viewController = PlayerViewController()
            let viewModel = PlayerViewModel(title: title, player: UIApplication.provider.player, tracks: tracks, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        case .album(let album, let sceneCoordinator):
            let albumRepository = AlbumRepository(album: album, network: UIApplication.provider.network, storage: UIApplication.provider.storage)
            var viewController = AlbumViewController()
            let viewModel = AlbumViewModel(albumRepository: albumRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        }
    }
    
}
