//
//  Network.swift
//  Spochify
//
//  Created by Alberto on 06/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

class Network {
    
    var locale: String {
        return Locale.current.languageCode ?? "es"
    }
    
    var country: String {
        return Locale.current.regionCode ?? "es"
    }
    
    lazy var categoriesUrl = URL(string: "https://api.spotify.com/v1/browse/categories?country=\(country)&locale=\(locale)&limit=50&offset=0")!
    
    var categoriesRequest: URLRequest {
        var request = URLRequest(url: categoriesUrl)
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(Storage.accessToken)"]
        return request
    }
    
}
