//
//  User.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

struct User: Equatable {
    let id: String
    let name: String
    let email: String
    let country: String
    let image: URL?
}
