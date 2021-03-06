//
//  StartViewModel.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift
import Action

class StartViewModel {
    
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
    
    var featuredPlaylists: Observable<[Playlist]> {
        return browseRepository
            .featured
            .map({ $0.sorted(by: { $0.name < $1.name })})
    }
    
    lazy var start: Observable<Start> = browseRepository.start.map { (start) -> Start in
        return Start(featured: start.featured.sorted(by: { $0.name < $1.name }), newReleases: start.newReleases.sorted(by: { $0.name < $1.name }))
    }
    
    lazy var hasTracks: Observable<Void> = player.hasTracks
    
    func tapped(playlist: Playlist) -> Observable<Void> {
        return sceneCoordinator
            .transition(to: Scene.playlist(playlist: playlist, sceneCoordinator: sceneCoordinator), type: SceneTransitionType.push)
            .andThen(Observable.empty())
    }
    
    func tapped(album: Album) -> Observable<Void> {
        return sceneCoordinator
            .transition(to: Scene.album(album: album, sceneCoordinator: sceneCoordinator), type: SceneTransitionType.push)
            .andThen(Observable.empty())
    }
    
}
