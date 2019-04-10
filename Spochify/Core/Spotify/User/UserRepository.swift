//
//  UserRepository.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift
import RxCocoa

class UserRepository {
    
    private let network: Network
    private let urlSession: URLSession
    
    init(network: Network,
         urlSession: URLSession) {
        self.network = network
        self.urlSession = urlSession
    }
    
    lazy var user: Observable<User> = urlSession.rx.response(request: network.currentUserRequest)
        .map({ (_, data) -> UserCodable in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(UserCodable.self, from: data)
        }).map({ (codable) -> User in
            return User(id: codable.id, name: codable.displayName, email: codable.email, country: codable.country, image: URL(string: codable.images?.first?.url))
        })
    
    lazy var isNotAuthenticated: Observable<Void> = urlSession.rx
        .response(request: network.currentUserRequest)
        .filter({response, data in response.statusCode == 401 || response.statusCode == 400 })
        .map({ (_,_) -> Void in })
        .debug()
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
