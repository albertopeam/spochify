//
//  NSLocalizedString+Init.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

enum Scene {
    case login(sceneCoordinator: SceneCoordinatorType)
    case playlist(playlist: Playlist, sceneCoordinator: SceneCoordinatorType)
    case categoryPlaylists(category: Category, sceneCoordinator: SceneCoordinatorType)
    case player(playlist: Playlist, sceneCoordinator: SceneCoordinatorType)
    case album(album: Album, sceneCoordinator: SceneCoordinatorType)
}
