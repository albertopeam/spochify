//
//  UIViewController+Constraints.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addStickedView(_ newView: UIView) {
        view.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newView.topAnchor.constraint(equalTo: view.topAnchor),
            newView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
}
