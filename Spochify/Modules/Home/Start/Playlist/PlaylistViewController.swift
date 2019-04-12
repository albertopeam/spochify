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
        tableView.rowHeight = 58
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TrackTableViewCell.identifier)
    }
    
    func bindViewModel() {
        //TODO: reload widget
        //TODO: row deselect
        viewModel.currentPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (playlist) in
                //TODO: playlist header
            })
            .disposed(by: disposeBag)        
        viewModel.tracks
            .bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.identifier)) { index, model, cell in
                guard let cell = cell as? TrackTableViewCell else { fatalError() }
                cell.draw(index: index + 1, track: model)
            }.disposed(by: disposeBag)
        tableView.rx
            .modelSelected(Track.self)
            .subscribe(onNext: { (track) in
                //TODO:
            }).disposed(by: disposeBag)
    }

}
