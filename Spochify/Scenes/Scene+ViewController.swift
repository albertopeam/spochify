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
        case .home:
            return HomeBuilder().build()
        //TODO: ????
        case .start(let viewModel):
            return StartBuilder().build()
        case .search(let viewModel):
            return SearchBuilder().build()
        case .login:
            return LoginViewController()
        case .playlist(let playlist, let sceneCoordinator):
            let viewController = PlaylistViewController()
            let playlistRepository = PlaylistRepository(playlistId: playlist.id)
            let viewModel = PlaylistViewModel(playlist: playlist, playlistRepository: playlistRepository, sceneCoordinator: sceneCoordinator)
            viewController.bindToViewModel(to: viewModel)
            return viewController
        }
    }
}
