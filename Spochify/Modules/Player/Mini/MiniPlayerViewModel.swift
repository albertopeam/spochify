//
//  MiniPlayerViewModel.swift
//  Spochify
//
//  Created by Alberto on 23/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class MiniPlayerViewModel {
    
    private let player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    lazy var currentProgress = self.player.progress
    lazy var playing = self.player.playing
    lazy var currentTrack = self.player.track
    lazy var playAction = self.player.play
    lazy var pauseAction = self.player.pause
}
