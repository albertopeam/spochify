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
    let urlSession: URLSession
    
    //TODO: cache URLSession, revisar si spotify devuelve e-tag o last-mod
    init(urlSession: URLSession,
         storage: Storage) {
        self.urlSession = urlSession
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
        return "2019-04-11T09:00:00"
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
    
    // MARK: playlist
    
    private lazy var playlistTracksfields = "limit,next,offset,previous,total,items(track(id,name,popularity,explicit,preview_url,album(id,release_date,total_tracks,name,images)))"
    private lazy var playlistTracks = "\(endpoint)/playlists/{playlist_id}/tracks?limit=100&offset=0&market=\(country)&fields=\(playlistTracksfields)"
    func playlistTracksRequest(playlistId: String) -> URLRequest {
        let concretePlaylistTracks = playlistTracks.replacingOccurrences(of: "{playlist_id}", with: playlistId)
        let playlistTracksUrl = URL(string: concretePlaylistTracks)!
        print(playlistTracksUrl)
        var request = URLRequest(url: playlistTracksUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(storage.accessToken)"]
        return request
    }
    
}
