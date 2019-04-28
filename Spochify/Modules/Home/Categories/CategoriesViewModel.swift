//
//  SearchViewModel.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift
import Action

class CategoriesViewModel {
    
    private let browseRepository: BrowseRepository
    private let sceneCoordinator: SceneCoordinatorType
    private let player: Player
    
    init(browseRepository: BrowseRepository,
         sceneCoordinator: SceneCoordinatorType,
         player: Player) {
        self.browseRepository = browseRepository
        self.sceneCoordinator = sceneCoordinator
        self.player = player
    }
    
    lazy var categories: Observable<[Category]> = browseRepository.categories
        .map({ $0.sorted(by: { $0.name < $1.name }) })
    
    lazy var hasTracks: Observable<Void> = player.hasTracks
    
    lazy var tappedCategory: Action<Category, Void> = Action { category in
        return self.sceneCoordinator
            .transition(to: Scene.categoryPlaylists(category: category, sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.push)
            .andThen(Observable<Void>.empty())
    }

}
