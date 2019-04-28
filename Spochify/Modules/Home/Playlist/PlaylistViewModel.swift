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

    lazy var fullPlaylist: Observable<Playlist> = playlistRepository.fullPlaylist
    lazy var emptyTracks: Observable<Bool> = playlistRepository.fullPlaylist.map({ $0.tracks }).map { (tracks) -> Bool in tracks.filter({ $0.url != nil }).count == 0 }
    
    lazy var tappedPlay: Action<Playlist, Void> = Action { playlist in
        return self.sceneCoordinator
            .transition(to: Scene.player(title: playlist.name, tracks: playlist.tracks, sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
            .andThen(Observable<Void>.empty())
    }
    
}
