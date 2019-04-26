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
        case tabCategories = "tab_categories"
        // NAV
        case navStart = "nav_start"
        case navCategories = "nav_categories"
        case navAlbum = "nav_album"
        // UI
        case buttonPlay = "play_button"
        // START
        case startFeatured = "Featured"
        case startNewReleases = "section_new_releases"
    }
    
    init(localizedKey: String.Key) {
        self = NSLocalizedString(localizedKey.rawValue, comment: "")
    }
    
}
