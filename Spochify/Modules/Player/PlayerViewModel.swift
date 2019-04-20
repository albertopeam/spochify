//
//  PlayerViewModel.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift
import Action

class PlayerViewModel {
    
    private let playlist: Playlist
    private let player: Player
    private let sceneCoordinator: SceneCoordinatorType
    
    init(playlist: Playlist,
         player: Player,
         sceneCoordinator: SceneCoordinatorType) {
        self.playlist = playlist
        self.player = player
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var currentPlaylist = Observable<Playlist>.just(playlist)
    lazy var progress = self.player.progress
    lazy var playing = self.player.playing
    lazy var track = self.player.tracks(tracks: self.playlist.tracks)
    lazy var playAction = self.player.play
    lazy var pauseAction = self.player.pause
    lazy var nextAction = self.player.next
    lazy var previousAction = self.player.previous
    
    //    lazy var closeAction = Action<Void, Void> {
    //        return self.sceneCoordinator.pop(animated: true)
    //            .andThen(Observable<Void>.empty())
    //    }
}
