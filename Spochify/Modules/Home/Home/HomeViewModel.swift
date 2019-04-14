//
//  HomeViewModel.swift
//  Spochify
//
//  Created by Alberto on 14/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift

class HomeViewModel {
    
    private let userRepository: UserRepository
    private let sceneCoordinator: SceneCoordinatorType
    //TODO: forward vc bag...?
    private var disposeBag = DisposeBag()
    
    lazy var isAuth: Observable<Bool> = userRepository.user.map { (user) -> Bool in
        return true
    }
    
    init(userRepository: UserRepository, sceneCoordinator: SceneCoordinatorType) {
        self.userRepository = userRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    func binded() {
        userRepository
            .isNotAuthenticated
            //TODO: intercept, open next scene with params, if respond ok, dismiss
            //TODO: aún no se como hacerlo
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                self.sceneCoordinator.transition(to: Scene.login, type: SceneTransitionType.modal)
                //TODO: chola el dismiss
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                //                    self.sceneCoordinator.pop()
                //                })
            })
            .disposed(by: disposeBag)
    }
    
}
