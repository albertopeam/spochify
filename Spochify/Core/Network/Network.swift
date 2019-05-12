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
    private let credential: Credential
    let urlSession: URLSession
    
    //TODO: cache URLSession, check spotify api to analyse if they handle etags and if-none-match
    //TODO: try to remove the storage and inject the Variable to accessToken... less coupling or inject market always
    init(urlSession: URLSession,
         storage: Storage,
         credential: Credential) {
        self.urlSession = urlSession
        self.storage = storage
        self.credential = credential
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
    private lazy var newReleasesUrl = URL(string: "\(endpoint)/browse/new-releases?country=\(country)&limit=50&offset=0")!
    
    func categoriesRequest(accessToken: String) -> URLRequest {
        return request(for: categoriesUrl, accessToken: accessToken)
    }
    
    func categoryPlaylist(categoryId: String, accessToken: String) -> URLRequest {
        let catetoryPlaylistUrl = URL(string: categoryPlaylist.replacingOccurrences(of: "{category_id}", with: categoryId))!
        return request(for: catetoryPlaylistUrl, accessToken: accessToken)
    }
    
    func featuredPlayListRequest(accessToken: String) -> URLRequest {
        return request(for: featuredPlayListUrl, accessToken: accessToken)
    }
    
    func newReleases(accessToken: String) -> URLRequest {
        return request(for: newReleasesUrl, accessToken: accessToken)
    }
    
    // MARK: user
    
    func currentUserRequest(accessToken: String) -> URLRequest {
        return request(for: URL(string: endpoint + "/me")!, accessToken: accessToken)
    }
    
    // MARK: auth
    
    var loginUserRequest: URLRequest {
        let clientId = credential.clientId
        let responseType = "token"
        let scopes = "user-read-email user-read-private".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let redirectUri = credential.redirectUri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let state = "spochify"
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(clientId)&response_type=\(responseType)&redirect_uri=\(redirectUri)&state=\(state)&scope=\(scopes)")!
        return URLRequest(url: url)
    }
    
    // MARK: playlist
    
    private lazy var playlistTracksfields = "limit,next,offset,previous,total,items(track(id,name,popularity,explicit,preview_url,album(id,release_date,total_tracks,name,images)))"
    private lazy var playlistTracks = "\(endpoint)/playlists/{playlist_id}/tracks?limit=100&offset=0&market=\(country)&fields=\(playlistTracksfields)"
    func playlistTracksRequest(playlistId: String, accessToken: String) -> URLRequest {
        let concretePlaylistTracks = playlistTracks.replacingOccurrences(of: "{playlist_id}", with: playlistId)
        return request(for: URL(string: concretePlaylistTracks)!, accessToken: accessToken)
    }
    
    // MARK: album
    
    func albumTracksRequest(albumId: String, accessToken: String) -> URLRequest {
        let albumTracks = "\(endpoint)/albums/{album_id}/tracks?limit=50&offset=0&market=\(country)".replacingOccurrences(of: "{album_id}", with: albumId)
        return request(for: URL(string: albumTracks)!, accessToken: accessToken)
    }
    
    // MARK: private
    
    private func request(for url: URL, accessToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)"]
        return request
    }
    
}
