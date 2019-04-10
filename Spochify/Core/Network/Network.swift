//
//  Network.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Network {
    
    private let endpoint = "https://api.spotify.com/v1"
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    private var locale: String {
        return "es"//Locale.current.languageCode ?? "es"
    }
    
    private var country: String {
        return "es"//Locale.current.regionCode ?? "es"
    }
    
    private var timestamp: String {
        //TODO: formatter
        return "2019-04-06T22:00:00"
    }
    
    // MARK: browse
    private lazy var categoriesUrl = URL(string: "https://api.spotify.com/v1/browse/categories?country=\(country)&locale=\(locale)&limit=50&offset=0")!
    
    private lazy var featuredPlayListUrl = URL(string: "https://api.spotify.com/v1/browse/featured-playlists?country=\(country)&locale=\(locale)&timestamp=\(timestamp)&limit=50&offset=0")!
    
    var categoriesRequest: URLRequest {
        var request = URLRequest(url: categoriesUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(storage.accessToken)"]
        return request
    }
    
    var featuredPlayListRequest: URLRequest {
        var request = URLRequest(url: featuredPlayListUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(storage.accessToken)"]
        return request
    }
    
    //TODO:
    //Get a playlist
    //get playlist tracks
    
    // MARK: user
    
    private lazy var currentUserUrl = URL(string: endpoint + "/me")!
    
    var currentUserRequest: URLRequest {
        var request = URLRequest(url: currentUserUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(storage.accessToken)"]
        return request
    }
    
}
