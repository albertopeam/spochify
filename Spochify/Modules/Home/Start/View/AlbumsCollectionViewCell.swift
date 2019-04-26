//
//  AlbumsCollectionViewCell.swift
//  Spochify
//
//  Created by Alberto on 25/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class AlbumsCollectionViewCell: HorizontalCollectionViewCell, HorizontalCollectionViewCellData {
    typealias Item = Album
    
    static var identifier: String = "AlbumsCollectionViewCell"
    var items: [Album] = [] {
        didSet {
            draw()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func draw() {
        Observable<[Album]>
            .of(items)
            .bind(to: collectionView.rx.items(cellIdentifier: AlbumCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? AlbumCollectionViewCell else { fatalError() }
                cell.draw(album: model)
            }
            .disposed(by: disposeBag)
    }
    
}
