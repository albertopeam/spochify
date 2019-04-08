//
//  HomeBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class HomeBuilder {
    
    func build() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [StartBuilder().build(), SearchBuilder().build()]
        return tabBarController
    }
    
}
