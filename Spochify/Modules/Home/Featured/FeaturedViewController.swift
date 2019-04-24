//
//  StartViewController.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController
import RxSwift
import RxDataSources

//TODO: add collection view horizontal with another playlists
class FeaturedViewController: UICollectionViewController, BindableType {
    typealias ViewModelType = FeaturedViewModel
    
    private let flowLayout: UICollectionViewFlowLayout
    private let refreshControl: UIRefreshControl
    private let columns = 2
    private let disposeBag = DisposeBag()
    var viewModel: FeaturedViewModel!

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
        title = String(localizedKey: String.Key.navFeatured)
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        //TODO: migrate to something more scalable
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0)
        refreshControl.beginRefreshing()
        flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.featuredPlaylists
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                self.refreshControl.endRefreshing()
            }, onError: { (_) in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        viewModel.featuredPlaylists
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PlaylistCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? PlaylistCollectionViewCell else { fatalError() }
                cell.draw(playlist: model)
            }
            .disposed(by: disposeBag)
        collectionView.rx
            .modelSelected(Playlist.self)
            .subscribe(onNext: { [unowned self] (playlist) in
                self.viewModel.tapped(playlist: playlist)
            })
            .disposed(by: disposeBag)
    }
    
}
