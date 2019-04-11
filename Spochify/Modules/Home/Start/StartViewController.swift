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

class StartViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private let columns = 2
    private let viewModel: StartViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "StartViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: make an extension with a computed property
        //let size = (UIScreen.main.bounds.width - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / CGFloat(columns)
        //flowLayout.itemSize = CGSize(width: size, height: size)
        
        flowLayout.numberOfColumns(columns)
        collectionView.register(UINib(nibName: "PlaylistCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: PlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        
        viewModel.featuredPlaylists
            .bind(to: collectionView.rx.items(cellIdentifier: PlaylistCollectionViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? PlaylistCollectionViewCell else { fatalError() }
                cell.draw(playlist: model)
            }.disposed(by: disposeBag)
    }
    
}

extension StartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("touched")
        //TODO: how to navigate from here?
        //Playlist trackshttps://api.spotify.com/v1/playlists/{playlist_id}/tracks
        //https://developer.spotify.com/console/get-playlist-tracks/?playlist_id=&market=&fields=&limit=&offset=
    }
}

extension UICollectionViewFlowLayout {
    
    func numberOfColumns(_ columns: Int) {
        let size = (UIScreen.main.bounds.width - minimumInteritemSpacing - sectionInset.left - sectionInset.right) / CGFloat(columns)
        itemSize = CGSize(width: size, height: size)
    }
    
}
