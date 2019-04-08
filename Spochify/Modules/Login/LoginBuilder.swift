//
//  LoginBuilder.swift
//  Spochify
//
//  Created by Alberto on 08/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class LoginBuilder {
    
    func build() -> UIViewController {
        return UINavigationController(rootViewController: LoginViewController())
    }
    
}
