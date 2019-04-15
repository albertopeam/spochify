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

class PlaylistViewController: UITableViewController, BindableType {
    typealias ViewModelType = PlaylistViewModel
    
    private let disposeBag = DisposeBag()
    var viewModel: PlaylistViewModel!
    
    private enum ViewTraits {
        static let rowHeight: CGFloat = 58
    }
    
    init() {
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = ViewTraits.rowHeight
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TrackTableViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: PlaylistHeaderView.ViewTraits.height)
    }
    
    func bindViewModel() {
        viewModel.currentPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (playlist) in
                self.title = playlist.name
                self.tableView.tableHeaderView = PlaylistHeaderView(playlist: playlist, action: self.viewModel.playAction)
            })
            .disposed(by: disposeBag)
        
        viewModel.tracks
            .bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? TrackTableViewCell else { fatalError() }
                cell.draw(index: index + 1, track: model)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
    }
    
}
