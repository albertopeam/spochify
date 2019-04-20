//
//  Playlist.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Playlist: Equatable {
    let id: String
    let name: String
    let image: URL?
    let tracks: [Track]
}
