//
//  PlayerRemoteControls.swift
//  Spochify
//
//  Created by Alberto on 22/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import MediaPlayer

class PlayerRemoteControls {
    
    private let commandCenter: MPRemoteCommandCenter
    private let player: Player
    
    init(commandCenter: MPRemoteCommandCenter = MPRemoteCommandCenter.shared(),
         player: Player) {
        self.commandCenter = commandCenter
        self.player = player
        self.commandCenter.playCommand.isEnabled = true
        self.commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            player.play.execute()
            return MPRemoteCommandHandlerStatus.success
        }
        self.commandCenter.pauseCommand.isEnabled = true
        self.commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            player.pause.execute()
            return MPRemoteCommandHandlerStatus.success
        }
        self.commandCenter.previousTrackCommand.isEnabled = true
        self.commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            player.next.execute()
            return MPRemoteCommandHandlerStatus.success
        }
        self.commandCenter.nextTrackCommand.isEnabled = true
        self.commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            player.previous.execute()
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
}
