//
//  UITableView+Molds.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    
    static var mold: UITableView {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TrackTableViewCell.identifier)
        tableView.refreshControl = UIRefreshControl.mold
        tableView.alwaysBounceVertical = true
        tableView.refreshControl?.beginRefreshing()
        return tableView
    }
}
