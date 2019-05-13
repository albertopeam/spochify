//
//  PlaylistRepository.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxCocoa
import RxSwift

class PlaylistRepository {
    
    private let playlist: Playlist
    private let network: Network
    private let storage: Storage
    
    init(playlist: Playlist,
         network: Network,
         storage: Storage) {
        self.playlist = playlist
        self.network = network
        self.storage = storage
    }
    
    lazy var fullPlaylist: Observable<Playlist> = storage
        .accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.playlistTracksRequest(playlistId: self.playlist.id, accessToken: $0)) })
        .map({ (response, data) -> TrackListCodable? in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try? decoder.decode(TrackListCodable.self, from: data)
        })
        .flatMap({ Observable.from(optional: $0?.items) })
        .flatMap({ (items) -> Observable<Playlist> in
            let tracks = items.map({ (item) -> Track in
                let album = Album(id: item.track.album.id,
                                  name: item.track.album.name,
                                  releaseDate: DateFormatter().toDate(string: item.track.album.releaseDate),
                                  numTracks: item.track.album.totalTracks,
                                  image: URL(string: item.track.album.images?.first?.url),
                                  tracks: [])
                return Track(id: item.track.id,
                             title: item.track.name,
                             popularity: item.track.popularity,
                             url: item.track.previewUrl,
                             explicit: item.track.explicit,
                             album: album)
            })
            return Observable.just(Playlist(id: self.playlist.id, name: self.playlist.name, image: self.playlist.image, tracks: tracks))
        })        
        .share()
        .debug()
    
}

extension PlaylistRepository{
    private struct TrackListCodable: Codable {
        let items: [TrackCodable]
        
        struct TrackCodable: Codable {
            let track: InnerTrackCodable
        }
        
        struct InnerTrackCodable: Codable {
            let id: String
            let name: String
            let popularity: Int
            let previewUrl: URL?
            let explicit: Bool
            let album: AlbumCodable
        }
        
        struct ImageCodable: Codable {
            let url: String
        }
    }
    
}

