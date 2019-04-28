//
//  AlbumViewModel.swift
//  Spochify
//
//  Created by Alberto on 26/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift
import Action

class AlbumViewModel {
    
    private let albumRepository: AlbumRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(albumRepository: AlbumRepository,
         sceneCoordinator: SceneCoordinatorType) {
        self.albumRepository = albumRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var fullAlbum: Observable<Album> = albumRepository.fullAlbum
    lazy var tracks: Observable<[Track]> = albumRepository.fullAlbum.map({ $0.tracks })
    lazy var emptyTracks: Observable<Bool> = albumRepository.fullAlbum.map({ $0.tracks }).map { (tracks) -> Bool in tracks.filter({ $0.url != nil }).count == 0 }
    
    lazy var tappedPlay: Action<Album, Void> = Action { album in
        return self.sceneCoordinator
            .transition(to: Scene.player(title: album.name, tracks: album.tracks, sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
            .andThen(Observable<Void>.empty())
    }

}
