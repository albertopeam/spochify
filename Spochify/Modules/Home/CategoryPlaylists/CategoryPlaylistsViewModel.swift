//
//  CategoryPlaylistsViewModel.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift
import Action

class CategoryPlaylistsViewModel {
    
    private let category: Category
    private let browseRepository: BrowseRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(category: Category, browseRepository: BrowseRepository, sceneCoordinator: SceneCoordinatorType) {
        self.category = category
        self.browseRepository = browseRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    func currentCategory() -> Observable<Category> {
        return Observable.just(category)
    }
    
    func playlists() -> Observable<[Playlist]> {
        return browseRepository.playlistsForCategory(categoryId: category.id)
            .map({ $0.sorted(by: { $0.name < $1.name })})
    }
    
    lazy var tappedPlaylist: Action<Playlist, Void> = Action { playlist in
        return self.sceneCoordinator.transition(to: Scene.playlist(playlist: playlist, sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.push)
            .andThen(Observable<Void>.empty())
    }
    
}
