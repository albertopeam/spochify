//
//  SearchViewModel.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import RxSwift

class CategoriesViewModel {
    
    private let browseRepository: BrowseRepository
    private let sceneCoordinator: SceneCoordinatorType
    
    init(browseRepository: BrowseRepository, sceneCoordinator: SceneCoordinatorType) {
        self.browseRepository = browseRepository
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var categories: Observable<[Category]> = browseRepository.categories
    
}
