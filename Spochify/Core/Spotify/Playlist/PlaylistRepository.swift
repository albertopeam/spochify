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
    
    private let network: Network
    private let playlistId: String
    
    init(network: Network = Network(urlSession: URLSession.shared, storage: Storage()),
         playlistId: String) {
        self.network = network
        self.playlistId = playlistId
    }
    
    lazy var tracks: Observable<[Track]> = network.urlSession.rx.response(request: network.playlistTracksRequest(playlistId: playlistId))
        .filter({ response, _ in 200..<300 ~= response.statusCode })
        .map({ (_, data) in try? JSONDecoder().decode(TrackListCodable.self, from: data) })
        .flatMap({ Observable.from(optional: $0?.items) })
        .flatMap({ (items) -> Observable<[Track]> in
            let tracks = items.map({ (item) -> Track in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: item.album.releaseDate) ?? Date()
                let album = Album.init(id: item.album.id, name: item.album.name, releaseDate: date, numTracks: item.album.totalTracks, image: URL(string: item.album.images?.first?.url))
                return Track.init(id: item.id, name: item.name, popularity: item.popularity, url: item.previewUrl, explicit: item.explicit, album: album)
            })
            return Observable.just(tracks)
        })
        .share(replay: 1, scope: .forever)
        .debug()
    
}

extension PlaylistRepository{
    private struct TrackListCodable: Codable {
        let items: [TrackCodable]
        
        struct TrackCodable: Codable {
            let id: String
            let name: String
            let popularity: Int
            let previewUrl: URL?
            let explicit: Bool
            let album: AlbumCodable
        }
        
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
    }
    
}

