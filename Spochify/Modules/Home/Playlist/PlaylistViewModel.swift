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
    
    private let playlist: Playlist
    private let playlistRepository: PlaylistRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(playlist: Playlist,
         playlistRepository: PlaylistRepository,
         sceneCoordinator: SceneCoordinatorType) {
        self.playlist = playlist
        self.playlistRepository = playlistRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var currentPlaylist: Observable<Playlist> = Observable.just(playlist)
    
    lazy var tracks: Observable<[Track]> = playlistRepository.tracks
    
    lazy var playAction: Action<Void, Void> = Action {
        //TODO: play
        print("TODO: play")
        return Observable.empty()
    }
    
}
