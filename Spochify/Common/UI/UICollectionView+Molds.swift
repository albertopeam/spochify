//
//  UICollectionView.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionView {
    
    static var mold: UICollectionView {
        let refreshControl = UIRefreshControl.mold
        let flowLayout = UICollectionViewFlowLayout.mold()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistsCollectionViewCell.identifier)
        collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: AlbumsCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "HorizontalCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HorizontalCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.beginRefreshing()
        return collectionView
    }
    
}
