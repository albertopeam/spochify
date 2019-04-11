//
//  Album.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct Album {
    let id: String
    let name: String
    let releaseDate: Date
    let numTracks: Int
    let image: URL?
}
//"album": {
//    "id": "4OyP4eAtpTHXjpVBjJvPNG",
//    "images": [
//    {
//    "height": 640,
//    "url": "https://i.scdn.co/image/be7b75b6dde0ea407a96c9c358fd90ba6f738fa6",
//    "width": 640
//    },
//    {
//    "height": 300,
//    "url": "https://i.scdn.co/image/24b56a374206acec5676d9152baf59013bb6fb2c",
//    "width": 300
//    },
//    {
//    "height": 64,
//    "url": "https://i.scdn.co/image/0ec20fcc08b03a70cfb9d005e46cb1d3ce68c457",
//    "width": 64
//    }
//    ],
//    "name": "Pa Mí (Remix)",
//    "release_date": "2019-02-07",
//    "total_tracks": 1
//    }