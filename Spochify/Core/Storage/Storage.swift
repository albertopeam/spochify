//
//  Storage.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift

//TODO: maybe a better place to store it, keychain
class Storage {
    
    private let accessTokenKey = "accessToken"
    private let countryKey = "country"
    let accessTokenVariable: Variable<String> = Variable<String>("")
    private let tokenWritter: Observable<String>
    
    init() {
        tokenWritter = accessTokenVariable.asObservable()
        accessTokenVariable.value = accessToken
        _ = tokenWritter
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (newAccessToken) in
                self.accessToken = newAccessToken
            })
    }

    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: accessTokenKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
        }
    }
    
    var country: String {
        get {
            return UserDefaults.standard.string(forKey: countryKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: countryKey)
        }
    }
    
}
