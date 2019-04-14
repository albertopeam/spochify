//
//  NSLocalizedString+Init.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation

extension String {
    
    enum Key: String {
        case appName = "app_name"
        // TABS
        case tabStart = "tab_start"
        case tabSearch = "tab_search"
        // NAV
        case navFeatured = "nav_featured"
        // UI
        case buttonPlay = "play_button"
    }
    
    init(localizedKey: String.Key) {
        self = NSLocalizedString(localizedKey.rawValue, comment: "")
    }
    
}
