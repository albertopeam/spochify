//
//  StartBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIViewController

class StartBuilder {
    
    func build() -> UIViewController {
        let browseRepository = BrowseRepository(network: Network(storage: Storage()), urlSession: URLSession.shared)
        let startViewModel = StartViewModel(browseRepository: browseRepository)
        let viewController = StartViewController(viewModel: startViewModel)
        return viewController
    }
}
