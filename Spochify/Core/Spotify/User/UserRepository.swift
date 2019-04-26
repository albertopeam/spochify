//
//  UserRepository.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift
import RxCocoa

//TODO:
//TODO: remove all 200..300 to avoid never respond
//TODO:
class UserRepository {
    
    private let network: Network
    private let storage: Storage
    
    init(network: Network, storage: Storage) {
        self.network = network
        self.storage = storage
    }
    
    lazy var user: Observable<User> = storage.accessTokenVariable.asObservable()
        .flatMap({ (token) -> Observable<(response: HTTPURLResponse, data: Data)> in
            if token.isEmpty {
                throw Error.invalidToken
            }
            return self.network.urlSession.rx.response(request: self.network.currentUserRequest(accessToken: token))
        })
        .map({ (_, data) -> UserCodable in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(UserCodable.self, from: data)
        })
        .map({ (codable) -> User in
            return User(id: codable.id, name: codable.displayName, email: codable.email, country: codable.country, image: URL(string: codable.images?.first?.url))
        })
        .share()
        .debug()
    
    lazy var isNotAuthenticated: Observable<Void> = storage.accessTokenVariable.asObservable()
        .flatMap({ (token) -> Observable<(response: HTTPURLResponse, data: Data)> in
            if token.isEmpty {
                throw Error.invalidToken
            }
            return self.network.urlSession.rx.response(request: self.network.currentUserRequest(accessToken: token))
        })
        .filter({response, data in response.statusCode == 401 || response.statusCode == 400 })
        .map({ (_,_) -> Void in })
        .share()
        .debug()
    
    lazy var isNotAuth: Observable<Void> = storage.accessTokenVariable.asObservable()
        .flatMap({ (token) -> Observable<(response: HTTPURLResponse, data: Data)> in
            if token.isEmpty {
                throw Error.invalidToken
            }
            return self.network.urlSession.rx.response(request: self.network.currentUserRequest(accessToken: token))
        })
        .filter({response, data in response.statusCode == 401 || response.statusCode == 400 })
        .map({ (_,_) -> Void in })
        .share()
        .debug()
    
    
    lazy var isAuth: Observable<Void> = storage.accessTokenVariable.asObservable()
        .flatMap({ (token) -> Observable<(response: HTTPURLResponse, data: Data)> in
            if token.isEmpty {
                throw Error.invalidToken
            }
            return self.network.urlSession.rx.response(request: self.network.currentUserRequest(accessToken: token))
        })
        .filter({response, data in 200..<300 ~= response.statusCode })
        .map({ (_,_) -> Void in })
        .share()
        .debug()
    
    lazy var login: Observable<URLRequest> = Observable<URLRequest>.create { (observer) -> Disposable in
        observer.onNext(self.network.loginUserRequest)
        return Disposables.create()
    }
    
    lazy var accessToken: Variable<String> = storage.accessTokenVariable
    
    func store(user: User) {
        self.storage.country = user.country
    }
    
    enum Error: Swift.Error {
        case invalidToken
    }
}

private class UserCodable: Codable {
    let id: String
    let country: String
    let displayName: String
    let email: String
    let images: [ImageCodable]?
    struct ImageCodable: Codable {
        let url: String
    }
}
