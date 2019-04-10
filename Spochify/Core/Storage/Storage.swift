//
//  Storage.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

//TODO: maybe a better place to store it
class Storage {
    
    private let accessTokenKey = "accessToken"
    
    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: accessTokenKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
        }
    }
}
