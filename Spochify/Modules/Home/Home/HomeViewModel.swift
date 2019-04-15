//
//  HomeViewModel.swift
//  Spochify
//
//  Created by Alberto on 14/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift
import Action

class HomeViewModel {
    
    private let userRepository: UserRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(userRepository: UserRepository, sceneCoordinator: SceneCoordinatorType) {
        self.userRepository = userRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var user: Observable<User> = userRepository.user
    
    func storeAction(user: User) {
        _ = userRepository.store(user: user)
    }
    
    func errorAction(error: Error) {
        self.sceneCoordinator.transition(to: Scene.login(sceneCoordinator: self.sceneCoordinator), type: SceneTransitionType.modal)
    }
    
}
