//
//  BrowseRepository.swift
//  Spochify
//
//  Created by Alberto on 07/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxCocoa
import RxSwift

struct PlayList {
    let id: String
    let name: String
    let image: URL?
    let tracks: Int
}

class BrowseRepository {
    
    private let network: Network
    private let urlSession: URLSession
    
    init(network: Network,
         urlSession: URLSession) {
        self.network = network
        self.urlSession = urlSession
    }
    
    lazy var featured: Observable<[PlayList]> = urlSession.rx.response(request: network.featuredPlayListRequest)
        .filter({ response, _ in 200..<300 ~= response.statusCode })
        .map({ _, data in try? JSONDecoder().decode(FeaturedPlayListCodable.self, from: data)})
        .flatMap({ Observable.from(optional: $0?.playlists.items) })
        .flatMap({ (playlist) -> Observable<[PlayList]> in
            let items = playlist.map { PlayList(id: $0.id, name: $0.name, image: URL(string: $0.images?.first?.url ?? ""), tracks: $0.tracks.total) }
            return Observable.just(items)
        })
        .share(replay: 1, scope: .forever)

}


extension BrowseRepository {
    
    private struct FeaturedPlayListCodable: Codable {
        let playlists: PlayListsCodable
    }

    private struct PlayListsCodable: Codable {
        let items: [PlayListCodable]
    }

    private struct PlayListCodable: Codable {
        let id: String
        let name: String
        let images: [ImageCodable]?
        let tracks: Tracks
    }

    private struct ImageCodable: Codable {
        let height: Int
        let width: Int
        let url: String
    }

    private struct Tracks: Codable {
        let href: String
        let total: Int
    }

}
