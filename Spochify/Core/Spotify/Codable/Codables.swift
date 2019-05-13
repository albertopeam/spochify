//
//  Codables.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct AlbumCodable: Codable {
    let id: String
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let images: [ImageCodable]?
}

struct ImageCodable: Codable {
    let url: String
}
