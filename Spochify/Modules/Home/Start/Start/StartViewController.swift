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

class StartViewController: UIViewController, BindableType {
    typealias ViewModelType = StartViewModel
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private let columns = 2
    private var disposeBag = DisposeBag()
    var viewModel: StartViewModel!

    init() {
        super.init(nibName: "StartViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.numberOfColumns(columns)
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
    }
    
    func bindViewModel() {
        viewModel
            .featuredPlaylists
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
