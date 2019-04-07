//
//  Network.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Network {
    
    private var locale: String {
        return Locale.current.languageCode ?? "es"
    }
    
    private var country: String {
        return Locale.current.regionCode ?? "es"
    }
    
    private var timestamp: String {
        //TODO: formatter
        return "2019-04-06T22:00:00"
    }
    
    private lazy var categoriesUrl = URL(string: "https://api.spotify.com/v1/browse/categories?country=\(country)&locale=\(locale)&limit=50&offset=0")!
    
    private lazy var featuredPlayListUrl = URL(string: "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&locale=\(locale)&timestamp=\(timestamp)&limit=1000&offset=0")!
    
    var categoriesRequest: URLRequest {
        var request = URLRequest(url: categoriesUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(Storage.accessToken)"]
        return request
    }
    
    var featuredPlayListRequest: URLRequest {
        var request = URLRequest(url: featuredPlayListUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(Storage.accessToken)"]
        return request
    }
    
    //Get a playlist
    //get playlist tracks
    
}
