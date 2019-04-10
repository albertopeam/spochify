//
//  UIApplication.swift
//  Spochify
//
//  Created by Alberto on 09/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var instance: AppDelegate {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        } else {
            fatalError("UIApplication.shared.delegate isn't instance of AppDelegate")
        }
    }
    
}
