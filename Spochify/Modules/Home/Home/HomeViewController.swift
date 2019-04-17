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
//TODO: USE DRIVERS https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Traits.md#rxcocoa-traits
class HomeViewController: UITabBarController, BindableType {
    
    typealias ViewModelType = HomeViewModel
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
        viewModel.user
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
                switch event {
                case .next(let user):
                    self.viewModel.storeAction(user: user)
                case .error(let error):
                    self.viewModel.errorAction(error: error)
                default: break
                }
        }.disposed(by: disposeBag)
    }
    
}
