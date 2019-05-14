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

class StartViewController: UIViewController, BindableType {
    
    typealias ViewModelType = StartViewModel
    private let collectionView: UICollectionView
    private let columns: Float = 1.5
    private let disposeBag = DisposeBag()
    var viewModel: StartViewModel!
    
    init() {
        collectionView = UICollectionView.mold
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localizedKey: String.Key.navStart)
        addStickedView(collectionView)
        let flowLayout = collectionView.flowLayout
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let size = (UIScreen.main.bounds.width - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / CGFloat(columns)
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right, height: size)
    }
    
    func bindViewModel() {
        viewModel.start
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in self.collectionView.refreshControl?.endRefreshing() }, onError: { [unowned self] (_) in self.collectionView.refreshControl?.endRefreshing() })
            .disposed(by: disposeBag)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, StartModel>>(configureCell: { [unowned self] dataSource, table, indexPath, item in
            return self.cell(for: indexPath, item: item)
        })
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            return self.sectionHeader(dataSource: dataSource, indexPath: indexPath)
        }
        viewModel
            .start
            .map({ self.map(start: $0 )})
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.hasTracks
            .bind(onNext: { playing in self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0) })
            .disposed(by: disposeBag)
    }
    
    // MARK: private
    
    private func cell(for indexPath: IndexPath, item: StartModel) -> UICollectionViewCell {
        switch item {
        case .playlist(let playlistsViewModel):
            return self.playlistCell(playlistsViewModel: playlistsViewModel, indexPath: indexPath)
        case .albums(let albumsViewModel):
            return self.albumCell(albumsViewModel: albumsViewModel, indexPath: indexPath)
        }
    }

    private func albumCell(albumsViewModel: AlbumsViewModel, indexPath: IndexPath) -> AlbumsCollectionViewCell {
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

    private func playlistCell(playlistsViewModel: PlaylistsViewModel, indexPath: IndexPath) -> PlaylistsCollectionViewCell {
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
    }

    private func sectionHeader(dataSource: CollectionViewSectionedDataSource<SectionModel<String, StartViewController.StartModel>>, indexPath: IndexPath) -> HorizontalCollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: HorizontalCollectionReusableView.identifier,
                                                                           for: indexPath) as? HorizontalCollectionReusableView else {
                                                                            fatalError()
        }
        header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
        return header
    }

    private func map(start: Start) -> [SectionModel<String, StartModel>] {
        let playlistSection = SectionModel<String, StartModel>(model: String(localizedKey: String.Key.startFeatured),
                                                               items: [StartModel.playlist(playlistViewModel: PlaylistsViewModel(playlists: start.featured))])
        let albumsSection = SectionModel<String, StartModel>(model: String(localizedKey: String.Key.startNewReleases),
                                                             items: [StartModel.albums(albumsViewModel: AlbumsViewModel(albums: start.newReleases))])
        return [playlistSection, albumsSection]
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


