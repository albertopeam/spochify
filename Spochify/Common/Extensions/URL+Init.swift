//
//  URL+Init.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

extension URL {
    
    init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string: string)
    }
    
}
