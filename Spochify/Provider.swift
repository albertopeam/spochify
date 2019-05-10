//
//  Provider.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Provider {
    
    let network: Network
    let storage: Storage
    let userRepository: UserRepository
    let browseRepository: BrowseRepository
    let player: Player
    let remoteControls: PlayerRemoteControls
    
    init(urlSession: URLSession = .shared) {
        let credentials = Credentials()
        storage = Storage()
        network = Network(urlSession: urlSession, storage: storage, credential: credentials.get())
        userRepository = UserRepository(network: network, storage: storage)
        browseRepository = BrowseRepository(network: network, storage: storage)
        player = Player()
        remoteControls = PlayerRemoteControls(player: player)
    }
    
}
