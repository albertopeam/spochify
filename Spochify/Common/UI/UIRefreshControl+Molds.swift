//
//  UIRefreshControl+Molds.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIRefreshControl

extension UIRefreshControl {
    
    static var mold: UIRefreshControl {
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.tintColor = .gray
        return refreshControl
    }
    
}
