//
//  Album.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Album: Equatable {
    let id: String
    let name: String
    let releaseDate: Date
    let numTracks: Int
    let image: URL?
}
