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
//TODO: check dispose bag usage with [unowned self]
class HomeViewController: UITabBarController, BindableType {
    
    typealias ViewModelType = HomeViewModel
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private let playerView: MiniPlayerView
    
    init(playerView: MiniPlayerView) {
        self.playerView = playerView
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //playerView.heightAnchor.constraint(equalToConstant: MiniPlayerView.ViewTraits.height),
            playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabBar.frame.height)
            ])
    }
    
    func bindViewModel() {
        viewModel.user
            .observeOn(MainScheduler.instance)
            .subscribe { [unowned self] (event) in
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
