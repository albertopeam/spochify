//
//  UICollectionViewFlowLayout+Init.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    static func mold(inset: CGFloat = 8,
                     minLineSpacing: CGFloat = 8,
                     minInterItemSpacing: CGFloat = 8) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        flowLayout.minimumLineSpacing = minLineSpacing
        flowLayout.minimumInteritemSpacing = minInterItemSpacing
        return flowLayout
    }
    
}
