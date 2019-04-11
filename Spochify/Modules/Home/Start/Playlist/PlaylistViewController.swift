//
//  PlaylistViewController.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift

class PlaylistViewController: UITableViewController {
    
    private let playlistViewModel: PlaylistViewModel
    
    init(playlistViewModel: PlaylistViewModel) {
        self.playlistViewModel = playlistViewModel
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TrackTableViewCell.identifier)
    }

}
