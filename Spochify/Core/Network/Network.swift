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
        return Locale.current.languageCode ?? "es"
    }
    
    private var country: String {
        return storage.country.isEmpty ? Locale.current.regionCode ?? "es" : storage.country
    }
    
    private var timestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let now = Date()
        return dateFormatter.string(from: now)
    }
    
    // MARK: browse
    private lazy var categoriesUrl = URL(string: "\(endpoint)/browse/categories?country=\(country)&locale=\(locale)&limit=50&offset=0")!
    private lazy var categoryPlaylist = "\(endpoint)/browse/categories/{category_id}/playlists"
    private lazy var featuredPlayListUrl = URL(string: "\(endpoint)/browse/featured-playlists?country=\(country)&locale=\(locale)&timestamp=\(timestamp)&limit=50&offset=0")!
    
    func categoriesRequest(accessToken: String) -> URLRequest {
        var request = URLRequest(url: categoriesUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
        return request
    }
    
    func categoryPlaylist(playlistId: String, accessToken: String) -> URLRequest {
        let catetoryPlaylistUrl = URL(string: categoryPlaylist.replacingOccurrences(of: "{category_id}", with: playlistId))!
        var request = URLRequest(url: catetoryPlaylistUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
        return request
    }
    
    func featuredPlayListRequest(accessToken: String) -> URLRequest {
        var request = URLRequest(url: featuredPlayListUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
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
    
    // MARK: auth
    
    var loginUserRequest: URLRequest {
        //TODO: move clientId to PLIST, not commit to repo
        let clientId = "b27608372edf492a85c3e4df2fe914fb"
        let responseType = "token"
        let scopes = "user-read-email user-read-private".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let redirectUri = "https://spochify.com/callback".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let state = "spochify"
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(clientId)&response_type=\(responseType)&redirect_uri=\(redirectUri)&state=\(state)&scope=\(scopes)")!
        return URLRequest(url: url)
    }
    
    // MARK: playlist
    
    private lazy var playlistTracksfields = "limit,next,offset,previous,total,items(track(id,name,popularity,explicit,preview_url,album(id,release_date,total_tracks,name,images)))"
    private lazy var playlistTracks = "\(endpoint)/playlists/{playlist_id}/tracks?limit=100&offset=0&market=\(country)&fields=\(playlistTracksfields)"
    func playlistTracksRequest(playlistId: String, accessToken: String) -> URLRequest {
        let concretePlaylistTracks = playlistTracks.replacingOccurrences(of: "{playlist_id}", with: playlistId)
        let playlistTracksUrl = URL(string: concretePlaylistTracks)!
        print(playlistTracksUrl)
        var request = URLRequest(url: playlistTracksUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
        return request
    }
    
}
