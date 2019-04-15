//
//  HomeViewController.swift
//  Spochify
//
//  Created by Alberto on 14/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift

//TODO: handle no network!!!
class HomeViewController: UITabBarController, BindableType {
    
    typealias ViewModelType = HomeViewModel
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.binded()
    }
    
}
