//
//  PlaylistViewModel.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift
import Action

class PlaylistViewModel {
    
    private let playlistRepository: PlaylistRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(playlistRepository: PlaylistRepository,
         sceneCoordinator: SceneCoordinatorType) {
        self.playlistRepository = playlistRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var currentPlaylist = playlistRepository.fullPlaylist
    
    lazy var tappedPlay: Action<Void, Void> = Action {
        return self.playlistRepository.fullPlaylist.flatMap({ (playlist) -> Observable<Void> in
            return self.sceneCoordinator
                .transition(to: Scene.player(playlist: playlist, sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
                .andThen(Observable<Void>.empty())
        })
    }
    
}
