//
//  CategoryPlaylistsViewController.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift

class CategoryPlaylistsViewController: UIViewController, BindableType {
    
    typealias ViewModelType = CategoryPlaylistsViewModel
    private let collectionView: UICollectionView
    private let columns: Float = 2
    private let disposeBag = DisposeBag()
    var viewModel: CategoryPlaylistsViewModel!
    
    init() {
        collectionView = UICollectionView.mold
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStickedView(collectionView)
        collectionView.flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.currentCategory()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (category) in self.title = category.name })
            .disposed(by: disposeBag)
        viewModel.playlists()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in self.collectionView.refreshControl?.endRefreshing() }, onError: { (_) in self.collectionView.refreshControl?.endRefreshing() })
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
            .flatMap({ [unowned self] in self.viewModel.tappedPlaylist.execute($0) })
            .subscribe()
            .disposed(by: disposeBag)
        viewModel.hasTracks
            .bind(onNext: { playing in self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0) })
            .disposed(by: disposeBag)
    }
    
}
