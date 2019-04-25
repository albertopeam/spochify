//
//  DateFormatter+Defaults.swift
//  Spochify
//
//  Created by Alberto on 24/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func toDate(string: String) -> Date {
        dateFormat = "yyyy-MM-dd"
        return date(from: string) ?? Date()
    }
    
}
