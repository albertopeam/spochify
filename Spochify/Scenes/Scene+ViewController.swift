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
            return loginScene(sceneCoordinator: sceneCoordinator)
        case .playlist(let playlist, let sceneCoordinator):
            return playlistScene(playlist: playlist, sceneCoordinator: sceneCoordinator)
        case .categoryPlaylists(let category, let sceneCoordinator):
            return categoryPlaylistsScene(category: category, sceneCoordinator: sceneCoordinator)
        case .player(let title, let tracks, let sceneCoordinator):
            return playerScene(title: title, tracks: tracks, sceneCoordinator: sceneCoordinator)
        case .album(let album, let sceneCoordinator):
            return albumScene(album: album, sceneCoordinator: sceneCoordinator)
        }
    }
    
    // MARK: private
    
    private func loginScene(sceneCoordinator: SceneCoordinatorType) -> UIViewController {
        let loginViewModel = LoginViewModel(userRepository: UIApplication.provider.userRepository, sceneCoordinator: sceneCoordinator)
        var viewController = LoginViewController()
        viewController.bindToViewModel(to: loginViewModel)
        return viewController
    }
    
    private func playlistScene(playlist: Playlist ,sceneCoordinator: SceneCoordinatorType) -> UIViewController {
        var viewController = PlaylistViewController()
        let playlistRepository = PlaylistRepository(playlist: playlist, network: UIApplication.provider.network, storage: UIApplication.provider.storage)
        let viewModel = PlaylistViewModel(playlistRepository: playlistRepository, sceneCoordinator: sceneCoordinator, player: UIApplication.provider.player)
        viewController.bindToViewModel(to: viewModel)
        return viewController
    }
    
    private func categoryPlaylistsScene(category: Category, sceneCoordinator: SceneCoordinatorType) -> UIViewController {
        let viewModel = CategoryPlaylistsViewModel(category: category, browseRepository: UIApplication.provider.browseRepository, sceneCoordinator: sceneCoordinator, player: UIApplication.provider.player)
        var viewController = CategoryPlaylistsViewController()
        viewController.bindToViewModel(to: viewModel)
        return viewController
    }
    
    private func playerScene(title: String, tracks: [Track], sceneCoordinator: SceneCoordinatorType) -> UIViewController {
        var viewController = PlayerViewController()
        let viewModel = PlayerViewModel(title: title, player: UIApplication.provider.player, tracks: tracks, sceneCoordinator: sceneCoordinator)
        viewController.bindToViewModel(to: viewModel)
        return viewController
    }
    
    private func albumScene(album: Album, sceneCoordinator: SceneCoordinatorType) -> UIViewController {
        let albumRepository = AlbumRepository(album: album, network: UIApplication.provider.network, storage: UIApplication.provider.storage)
        var viewController = AlbumViewController()
        let viewModel = AlbumViewModel(albumRepository: albumRepository, sceneCoordinator: sceneCoordinator, player: UIApplication.provider.player)
        viewController.bindToViewModel(to: viewModel)
        return viewController
    }

}
