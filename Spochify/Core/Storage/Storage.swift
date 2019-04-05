//
//  Storage.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Storage {
    
    private static let accessTokenKey = "accessToken"
    
    static var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: accessTokenKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
        }
    }
}
