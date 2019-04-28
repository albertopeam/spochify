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
    
    private let title: String
    private let player: Player
    private let sceneCoordinator: SceneCoordinatorType
    
    init(title: String,
         player: Player,
         tracks: [Track],
         sceneCoordinator: SceneCoordinatorType) {
        self.title = title
        self.player = player
        self.sceneCoordinator = sceneCoordinator
        self.player.playlist(with: tracks)
    }
    
    lazy var current = Observable<String>.just(title)
    lazy var progress = self.player.progress
    lazy var playing = self.player.playing
    lazy var currentTrack = self.player.track
    lazy var playAction = self.player.play
    lazy var pauseAction = self.player.pause
    lazy var nextAction = self.player.next
    lazy var previousAction = self.player.previous
    
    //    lazy var closeAction = Action<Void, Void> {
    //        return self.sceneCoordinator.pop(animated: true)
    //            .andThen(Observable<Void>.empty())
    //    }
}
