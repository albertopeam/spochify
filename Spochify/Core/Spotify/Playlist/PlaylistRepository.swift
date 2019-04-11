//
//  PlaylistRepository.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxCocoa
import RxSwift

class PlaylistRepository {
    
    private let network: Network
    private let playlistId: String
    
    init(network: Network,
         playlistId: String) {
        self.network = network
        self.playlistId = playlistId
    }
    
    //TODO: 
    var tracks: Observable<[Track]> = Observable.just([])
    
    
    
}
