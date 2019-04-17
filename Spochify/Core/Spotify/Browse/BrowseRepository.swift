//
//  BrowseRepository.swift
//  Spochify
//
//  Created by Alberto on 07/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxCocoa
import RxSwift

//TODO: 
//TODO: remove all 200..300 to avoid never respond
//TODO:
class BrowseRepository {
    
    private let network: Network
    private let storage: Storage
    
    init(network: Network, storage: Storage) {
        self.network = network
        self.storage = storage
    }
    
    lazy var featured: Observable<[Playlist]> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.featuredPlayListRequest(accessToken: $0)) })
        .filter({ response, _ in 200..<300 ~= response.statusCode })
        .map({ (_, data) in try? JSONDecoder().decode(PlayListResponseCodable.self, from: data) })
        .flatMap({ Observable.from(optional: $0?.playlists.items) })
        .flatMap({ (playlist) -> Observable<[Playlist]> in
            let items = playlist.map { Playlist(id: $0.id, name: $0.name, image: URL(string: $0.images?.first?.url ?? ""), tracks: []) }
            return Observable.just(items)
        })
        .share(replay: 1, scope: .forever)
        .debug()
    
    lazy var categories: Observable<[Category]> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.categoriesRequest(accessToken: $0)) })
        .map({ (_, data) in try? JSONDecoder().decode(CategoriesCodable.self, from: data) })
        .flatMap({ Observable.from(optional: $0?.categories.items) })
        .flatMap({ (categories) -> Observable<[Category]> in
            let items = categories.map { Category.init(id: $0.id, name: $0.name, image: URL(string: $0.icons?.first?.url)) }
            return Observable.just(items)
        })
        .share(replay: 1, scope: .forever)
        .debug()
    
    func playlistsForCategory(categoryId: String) -> Observable<[Playlist]>{
        return storage.accessTokenVariable.asObservable()
            .flatMap({ self.network.urlSession.rx.response(request: self.network.categoryPlaylist(categoryId: categoryId, accessToken: $0)) })
            .map({ (_, data) in try? JSONDecoder().decode(PlayListResponseCodable.self, from: data) })
            .flatMap({ Observable.from(optional: $0?.playlists.items) })
            .flatMap({ (playlist) -> Observable<[Playlist]> in
                let items = playlist.map { Playlist(id: $0.id, name: $0.name, image: URL(string: $0.images?.first?.url ?? ""), tracks: []) }
                return Observable.just(items)
            })
            .share(replay: 1, scope: .forever)
            .debug()
    }

}

extension BrowseRepository {
    
    // MARK: playlist
    
    private struct PlayListResponseCodable: Codable {
        let playlists: PlayListsCodable
        struct PlayListsCodable: Codable {
            let items: [PlayListCodable]
            struct PlayListCodable: Codable {
                let id: String
                let name: String
                let images: [ImageCodable]?
                let tracks: Tracks
                struct Tracks: Codable {
                    let href: String
                    let total: Int
                }
            }
        }
    }
    
    // MARK: categories

    private struct CategoriesCodable: Codable {
        let categories: CategoryListCodable
        struct CategoryListCodable: Codable {
            let items: [CategoryCodable]
            struct CategoryCodable: Codable {
                let id: String
                let name: String
                let icons: [ImageCodable]?
            }
        }
    }
    
    // MARK: shared
    
    private struct ImageCodable: Codable {
        let url: String
    }
}
