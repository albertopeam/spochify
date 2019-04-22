//
//  CategoryPlaylistsViewController.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift

class CategoryPlaylistsViewController: UICollectionViewController, BindableType {
    typealias ViewModelType = CategoryPlaylistsViewModel
    
    private let flowLayout: UICollectionViewFlowLayout
    private let refreshControl: UIRefreshControl
    private let columns = 2
    private let disposeBag = DisposeBag()
    var viewModel: CategoryPlaylistsViewModel!
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.tintColor = .gray
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        refreshControl.beginRefreshing()
        flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.currentCategory()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (category) in
                self.title = category.name
            })
            .disposed(by: disposeBag)
        
        viewModel.playlists()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                self.refreshControl.endRefreshing()
            }, onError: { (_) in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.playlists()
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PlaylistCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? PlaylistCollectionViewCell else { fatalError() }
                cell.draw(playlist: model)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Playlist.self)
            .flatMap({ self.viewModel.tappedPlaylist.execute($0) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
