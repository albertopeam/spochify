//
//  AlbumViewController.swift
//  Spochify
//
//  Created by Alberto on 25/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//TODO: sometimes fails loading... not doing requests...
//TODO: playlists 304, but I don't have content locally, maybe cache is removed(because of some reason, filesystem) and request headers etag/if-none not??? The request had etag
class AlbumViewController: UIViewController, BindableType {
    
    typealias ViewModelType = AlbumViewModel
    private let tableView: UITableView
    private let disposeBag = DisposeBag()
    private let header: AlbumHeaderView
    var viewModel: AlbumViewModel!
    
    private enum ViewTraits {
        static let rowHeight: CGFloat = 58
    }
    
    init() {
        tableView = UITableView.mold
        tableView.rowHeight = ViewTraits.rowHeight
        header = AlbumHeaderView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: AlbumHeaderView.ViewTraits.height)
    }
    
    func bindViewModel() {
        configureUI()
        configureActions()
    }
    
    // MARK: private
    
    private func configureUI() {
        viewModel.fullAlbum
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [unowned self] (album) in
                self.title = album.name
                self.tableView.tableHeaderView = self.header
                self.header.draw(album: album)
            })
            .disposed(by: disposeBag)
        viewModel.fullAlbum
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in self.tableView.refreshControl?.endRefreshing() })
            .disposed(by: disposeBag)
        viewModel.tracks
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? TrackTableViewCell else { fatalError() }
                cell.draw(index: index + 1, track: model)
            }
            .disposed(by: disposeBag)
        viewModel.hasTracks
            .bind(onNext: { [unowned self] playing in self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0) })
            .disposed(by: disposeBag)
    }
    
    private func configureActions() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in self.tableView.deselectRow(at: indexPath, animated: true)})
            .disposed(by: disposeBag)
        header.playButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .withLatestFrom(viewModel.fullAlbum)
            .bind(onNext: { [unowned self] in self.viewModel.tappedPlay.execute($0) })
            .disposed(by: disposeBag)
        viewModel.emptyTracks
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [unowned self] (empty) in self.header.playButton.isHidden = empty })
            .disposed(by: disposeBag)
    }
    
}
