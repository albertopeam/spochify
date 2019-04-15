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

class StartViewController: UICollectionViewController, BindableType {
    typealias ViewModelType = StartViewModel
    
    private let flowLayout: UICollectionViewFlowLayout
    private let columns = 2
    private let disposeBag = DisposeBag()
    var viewModel: StartViewModel!

    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
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
        flowLayout.numberOfColumns(columns)
    }
    
    func bindViewModel() {
        viewModel.featuredPlaylists
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PlaylistCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? PlaylistCollectionViewCell else { fatalError() }
                cell.draw(playlist: model)
            }.disposed(by: disposeBag)
        collectionView.rx
            .modelSelected(Playlist.self)
            .subscribe(onNext: { (playlist) in
                self.viewModel.tapped(playlist: playlist)
            }).disposed(by: disposeBag)
    }
    
}
