//
//  AppDelegate.swift
//  Spochify
//
//  Created by Alberto on 05/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window: UIWindow
    var provider: Provider = Provider()
    
    override init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var home = HomeBuilder().build()
        window.rootViewController = home.vc
        window.makeKeyAndVisible()
        home.vc.bindToViewModel(to: home.hvm)
        return true
    }

}

