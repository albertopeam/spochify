//
//  AlbumRepository.swift
//  Spochify
//
//  Created by Alberto on 26/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift

class AlbumRepository {
    
    private let network: Network
    private let album: Album
    private let storage: Storage
    
    init(album: Album,
         network: Network,
         storage: Storage) {
        self.album = album
        self.network = network
        self.storage = storage
    }
    
    lazy var fullAlbum: Observable<Album> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.albumTracksRequest(albumId: self.album.id, accessToken: $0)) })
        .map({ (_, data) -> TrackListCodable? in
            
            var decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(TrackListCodable.self, from: data)
        })
        .flatMap({ Observable.from(optional: $0?.items) })
        .flatMap({ (tracks) -> Observable<Album> in
            var fullAlbum = Album(id: self.album.id,
                                  name: self.album.name,
                                  releaseDate: self.album.releaseDate,
                                  numTracks: self.album.numTracks,
                                  image: self.album.image,
                                  tracks: [])
            fullAlbum.tracks = tracks.map({ Track.init(id: $0.id,
                                                       title: $0.name,
                                                       popularity: 0,
                                                       url: $0.previewUrl,
                                                       explicit: $0.explicit,
                                                       album: fullAlbum) })
            return Observable.just(fullAlbum)
        })
        .share()
        .debug()
    
    
    lazy var current: Observable<Album> = Observable.just(album)
    
}

extension AlbumRepository {
    private struct TrackListCodable: Codable {
        let items: [TrackCodable]
        struct TrackCodable: Codable {
            let id: String
            let name: String
            let previewUrl: URL?
            let explicit: Bool
        }
    }
}


