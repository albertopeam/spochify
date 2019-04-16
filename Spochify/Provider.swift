//
//  Provider.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Provider {
    
    let userRepository: UserRepository
    let browseRepository: BrowseRepository
    let playlistRepository: PlaylistRepository
    
    init(urlSession: URLSession = .shared) {
        let storage = Storage()
        let network = Network(urlSession: urlSession, storage: storage)
        userRepository = UserRepository(network: network, storage: storage)
        browseRepository = BrowseRepository(network: network, storage: storage)
        playlistRepository = PlaylistRepository(network: network, storage: storage)
    }
    
}
