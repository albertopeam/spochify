//
//  BrowseRepository.swift
//  Spochify
//
//  Created by Alberto on 07/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxCocoa
import RxSwift

class BrowseRepository {
    
    private let network: Network
    private let storage: Storage
    
    init(network: Network, storage: Storage) {
        self.network = network
        self.storage = storage
    }
    
    lazy var featured: Observable<[Playlist]> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.featuredPlayListRequest(accessToken: $0)) })
        .map({ (_, data) in try? JSONDecoder().decode(PlayListResponseCodable.self, from: data) })
        .flatMap({ Observable.from(optional: $0?.playlists.items) })
        .flatMap({ (playlist) -> Observable<[Playlist]> in
            return Observable.just(playlist.map { Playlist(id: $0.id,
                                                           name: $0.name,
                                                           image: URL(string: $0.images?.first?.url ?? ""),
                                                           tracks: []) }) })
        .share()
        .debug()
    
    lazy var newReleases: Observable<[Album]> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.newReleases(accessToken: $0)) })
        .map({ (_, data) -> AlbumsCodable? in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(AlbumsCodable.self, from: data)
            }catch {
                print(error)
                return nil
            }
        })
        .flatMap({ Observable.from(optional: $0?.albums.items) })
        .flatMap({ (albums) -> Observable<[Album]> in
            return Observable.just(albums.map { Album.init(id: $0.id,
                                                           name: $0.name,
                                                           releaseDate: DateFormatter().toDate(string: $0.releaseDate),
                                                           numTracks: $0.totalTracks,
                                                           image: URL(string: $0.images?.first?.url),
                                                           tracks: []) })
        })
        .share()
        .debug()

    lazy var start: Observable<Start> = Observable
        .zip(self.featured, self.newReleases) { Start(featured: $0, newReleases: $1) }
        .share()
        .debug()
    
    lazy var categories: Observable<[Category]> = storage.accessTokenVariable.asObservable()
        .flatMap({ self.network.urlSession.rx.response(request: self.network.categoriesRequest(accessToken: $0)) })
        .map({ (_, data) in try? JSONDecoder().decode(CategoriesCodable.self, from: data) })
        .flatMap({ Observable.from(optional: $0?.categories.items) })
        .flatMap({ (categories) -> Observable<[Category]> in
            return Observable.just(categories.map { Category.init(id: $0.id,
                                                                  name: $0.name,
                                                                  image: URL(string: $0.icons?.first?.url))
            })
        })
        .share()
        .debug()
    
    func playlistsForCategory(categoryId: String) -> Observable<[Playlist]>{
        return storage.accessTokenVariable.asObservable()
            .flatMap({ self.network.urlSession.rx.response(request: self.network.categoryPlaylist(categoryId: categoryId, accessToken: $0)) })
            .map({ (_, data) in try? JSONDecoder().decode(PlayListResponseCodable.self, from: data) })
            .flatMap({ Observable.from(optional: $0?.playlists.items) })
            .flatMap({ (playlist) -> Observable<[Playlist]> in
                return Observable.just(playlist.map { Playlist(id: $0.id,
                                                               name: $0.name,
                                                               image: URL(string: $0.images?.first?.url ?? ""),
                                                               tracks: []) })
            })
            .share()
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
    
    // MARK: releases
    
    private struct AlbumsCodable: Codable {
        let albums: AlbumListCodable
        struct AlbumListCodable: Codable {
            let items: [AlbumCodable]
            struct AlbumCodable: Codable {
                let id: String
                let name: String
                let releaseDate: String
                let totalTracks: Int
                let images: [ImageCodable]?
            }
        }
    }
    
    // MARK: shared
    
    private struct ImageCodable: Codable {
        let url: String
    }
}
