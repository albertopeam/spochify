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
import RxCocoa

//TODO: https://developer.spotify.com/console/get-recommendations/
//TODO: https://developer.spotify.com/console/get-available-genre-seeds/
class StartViewController: UICollectionViewController, BindableType {
    typealias ViewModelType = StartViewModel
    
    private let flowLayout: UICollectionViewFlowLayout
    private let refreshControl: UIRefreshControl
    private let columns: Float = 1.5
    private let disposeBag = DisposeBag()
    var viewModel: StartViewModel!
    
    init() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.tintColor = .gray
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localizedKey: String.Key.navStart)
        collectionView.backgroundColor = .white
        collectionView.register(PlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistsCollectionViewCell.identifier)
        collectionView.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: AlbumsCollectionViewCell.identifier)
        collectionView.register(HorizontalCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HorizontalCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: "HorizontalCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HorizontalCollectionReusableView.identifier)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        //TODO: migrate to something more scalable, listen to the player(through viewModel) to hide show
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0)
        refreshControl.beginRefreshing()
        let size = (UIScreen.main.bounds.width - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / CGFloat(columns)
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right, height: size)
    }
    
    func bindViewModel() {
        viewModel.start
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                self.refreshControl.endRefreshing()
                }, onError: { [unowned self] (_) in
                    self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, StartModel>>(configureCell: { [unowned self] dataSource, table, indexPath, item in
            switch item {
            case .playlist(let playlistsViewModel):
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsCollectionViewCell.identifier, for: indexPath) as? PlaylistsCollectionViewCell else {
                    fatalError()
                }
                cell.items = playlistsViewModel.playlists
                cell.collectionView.rx
                    .modelSelected(Playlist.self)
                    .flatMap({ self.viewModel.tapped(playlist: $0) })
                    .subscribe()
                    .disposed(by: cell.disposeBag)
                return cell
            case .albums(let albumsViewModel):
                guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: AlbumsCollectionViewCell.identifier, for: indexPath) as? AlbumsCollectionViewCell else {
                    fatalError()
                }
                cell.items = albumsViewModel.albums
                cell.collectionView.rx
                    .modelSelected(Album.self)
                    .flatMap({ self.viewModel.tapped(album: $0) })
                    .subscribe()
                    .disposed(by: cell.disposeBag)
                return cell
            }
        })
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: HorizontalCollectionReusableView.identifier,
                                                                               for: indexPath) as? HorizontalCollectionReusableView else {
                                                                                fatalError()
            }
            header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
            return header
        }
        
        viewModel
            .start
            .map { (start) -> [SectionModel<String, StartModel>] in
                let playlistSection = SectionModel<String, StartModel>(model: String(localizedKey: String.Key.startFeatured),
                                                                           items: [StartModel.playlist(playlistViewModel: PlaylistsViewModel(playlists: start.featured))])
                let albumsSection = SectionModel<String, StartModel>(model: String(localizedKey: String.Key.startNewReleases),
                                                                         items: [StartModel.albums(albumsViewModel: AlbumsViewModel(albums: start.newReleases))])
                return [playlistSection, albumsSection]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    enum StartModel {
        case playlist(playlistViewModel: PlaylistsViewModel)
        case albums(albumsViewModel: AlbumsViewModel)
    }
    
    struct PlaylistsViewModel {
        let playlists: [Playlist]
    }
    
    struct AlbumsViewModel {
        let albums: [Album]
    }
}


