//
//  StartViewModel.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift

class FeaturedViewModel {
    
    private let browseRepository: BrowseRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(browseRepository: BrowseRepository,
         sceneCoordinator: SceneCoordinatorType) {
        self.browseRepository = browseRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    var featuredPlaylists: Observable<[Playlist]> {
        return browseRepository
            .featured
            .map({ $0.sorted(by: { $0.name < $1.name })})
    }
    
    func tapped(playlist: Playlist) {
        sceneCoordinator.transition(to: Scene.playlist(viewModel: playlist, sceneCoordinator: sceneCoordinator), type: SceneTransitionType.push)
    }
    
}
