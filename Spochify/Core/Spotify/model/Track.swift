//
//  Track.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Track {
    let id: String
    let title: String
    let popularity: Int
    let url: URL?
    let explicit: Bool
    let album: Album
}
