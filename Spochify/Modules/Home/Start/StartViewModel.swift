//
//  StartViewModel.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import RxSwift

class StartViewModel {
    
    private let browseRepository: BrowseRepository
    
    init(browseRepository: BrowseRepository) {
        self.browseRepository = browseRepository
    }
    
    var featuredPlaylists: Observable<[Playlist]> {
        return browseRepository
            .featured
            .map({ $0.sorted(by: { $0.name < $1.name })})
    }
}
