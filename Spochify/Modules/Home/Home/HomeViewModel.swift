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
    
    //TODO: ??
    func binded() {
        userRepository
            .isNotAuth
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { () in
                print("isNotAuth onNext")
                self.sceneCoordinator.transition(to: Scene.login(sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
            }, onError: { (error) in
                print("isNotAuth onError")
                self.sceneCoordinator.transition(to: Scene.login(sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
            }, onCompleted: {
                print("isNotAuth onCompleted")
            })
            .disposed(by: disposeBag)
//        userRepository
//            .isAuth
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { () in
//                print("isAuth onNext")
//                self.sceneCoordinator.pop(animated: true)
//            }, onError: { (error) in
//                print("isAuth onError")
//                self.sceneCoordinator.pop(animated: true)
//            }, onCompleted: {
//                print("isAuth onCompleted")
//            })
//            .disposed(by: disposeBag)
    }
    
}
