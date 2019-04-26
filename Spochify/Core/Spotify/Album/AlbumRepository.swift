//
//  AlbumRepository.swift
//  Spochify
//
//  Created by Alberto on 26/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class AlbumRepository {
    
    private let network: Network
    private let album: Album
    
    init(album: Album,
         network: Network) {
        self.album = album
        self.network = network
    }
    
}
