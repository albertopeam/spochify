//
//  LoginViewModel.swift
//  Spochify
//
//  Created by Alberto on 14/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift
import Action

class LoginViewModel {
    
    private let userRepository: UserRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(userRepository: UserRepository, sceneCoordinator: SceneCoordinatorType) {
        self.userRepository = userRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var login: Observable<URLRequest> = userRepository.login
    
    lazy var parseTokenAction: Action<URL, Void> = Action { url in
        if url.host == "spochify.com", let fragment = url.fragment {
            if let accessToken = fragment.components(separatedBy: "&")
                .filter({ $0.contains("access_token")})
                .map({ $0.replacingOccurrences(of: "access_token=", with: "") })
                .first {
                return Observable<Void>.create({ (observer) -> Disposable in
                    self.userRepository.accessToken.value = accessToken
                    observer.onNext(())
                    return Disposables.create()
                }).flatMap({ () -> Observable<Void> in
                    self.sceneCoordinator.pop(animated: true)
                        .andThen(Observable.empty())
                })
            }
        }
        return Observable.empty()
    }
}
