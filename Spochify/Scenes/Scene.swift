//
//  NSLocalizedString+Init.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

enum Scene {
    case login
    case home
    case start(viewModel: StartViewModel)
    case search(viewModel: SearchViewModel)
    case playlist(viewModel: Playlist, sceneCoordinator: SceneCoordinatorType)
}
