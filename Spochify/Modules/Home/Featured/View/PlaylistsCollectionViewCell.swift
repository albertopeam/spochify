//
//  PlaylistsCollectionViewCell.swift
//  Spochify
//
//  Created by Alberto on 25/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class PlaylistsCollectionViewCell: HorizontalCollectionViewCell, HorizontalCollectionViewCellData {
    typealias Item = Playlist
    
    static var identifier: String = "PlaylistsCollectionViewCell"
    var items: [Playlist] = [] {
        didSet {
            draw()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw() {
        Observable<[Playlist]>
            .of(items)
            .bind(to: collectionView.rx.items(cellIdentifier: PlaylistCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? PlaylistCollectionViewCell else { fatalError() }
                cell.draw(playlist: model)
            }
            .disposed(by: disposeBag)
    }
    
}
