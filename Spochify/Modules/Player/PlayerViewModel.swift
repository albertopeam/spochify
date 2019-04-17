//
//  PlayerViewModel.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift

class PlayerViewModel {
    
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    lazy var currentPlaylist = Observable<Playlist>.just(playlist)
    
    func currentTrack() -> Observable<Track?> {
        return Observable.just(playlist.tracks.first)
    }

}
