//
//  PlaylistViewController.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlaylistViewController: UIViewController, BindableType {
    
    typealias ViewModelType = PlaylistViewModel
    private let tableView: UITableView
    private let header: PlaylistHeaderView
    private let disposeBag = DisposeBag()
    var viewModel: PlaylistViewModel!
    
    private enum ViewTraits {
        static let rowHeight: CGFloat = 58
    }
    
    init() {
        tableView = UITableView.mold
        tableView.rowHeight = ViewTraits.rowHeight
        header = PlaylistHeaderView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStickedView(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: PlaylistHeaderView.ViewTraits.height)
    }
    
    func bindViewModel() {
        configureUI()
        configureActions()
    }
    
    // MARK: private
    
    private func configureUI() {
        viewModel.fullPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in self.tableView.refreshControl?.endRefreshing() }, onError: { (_) in self.tableView.refreshControl?.endRefreshing() })
            .disposed(by: disposeBag)
        viewModel.fullPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (playlist) in
                self.title = playlist.name
                self.tableView.tableHeaderView = self.header
                self.header.draw(playlist: playlist)
            })
            .disposed(by: disposeBag)
        viewModel.fullPlaylist
            .observeOn(MainScheduler.instance)
            .map({ $0.tracks })
            .bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? TrackTableViewCell else { fatalError() }
                cell.draw(index: index + 1, track: model)
            }.disposed(by: disposeBag)
        viewModel.hasTracks
            .bind(onNext: { [unowned self] playing in self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: MiniPlayerView.ViewTraits.height, right: 0) })
            .disposed(by: disposeBag)
    }
    
    private func configureActions() {
        viewModel.emptyTracks
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [unowned self] (empty) in self.header.playButton.isHidden = empty })
            .disposed(by: disposeBag)
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in self.tableView.deselectRow(at: indexPath, animated: true) })
            .disposed(by: disposeBag)
        header.playButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .withLatestFrom(viewModel.fullPlaylist)
            .bind(onNext: { [unowned self] in self.viewModel.tappedPlay.execute($0) })
            .disposed(by: disposeBag)
    }
    
}
