//
//  PlaylistViewModel.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift

class PlaylistViewModel {
    
    private let playlist: Playlist
    private let playlistRepository: PlaylistRepository
    
    init(playlist: Playlist,
         playlistRepository: PlaylistRepository) {
        self.playlist = playlist
        self.playlistRepository = playlistRepository
    }
    
    lazy var currentPlaylist: Observable<Playlist> = Observable.just(playlist)
    lazy var tracks: Observable<[Track]> = playlistRepository.tracks
    
}
