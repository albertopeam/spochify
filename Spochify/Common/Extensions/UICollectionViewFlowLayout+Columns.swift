//
//  UICollectionViewFlowLayout+Columns.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    func numberOfColumns(_ columns: Int) {
        let size = (UIScreen.main.bounds.width - minimumInteritemSpacing - sectionInset.left - sectionInset.right) / CGFloat(columns)
        itemSize = CGSize(width: size, height: size)
    }
    
    func numberOfColumns(_ columns: Float) {
        let size = (UIScreen.main.bounds.width - minimumInteritemSpacing - sectionInset.left - sectionInset.right) / CGFloat(columns)
        itemSize = CGSize(width: size, height: size)
    }
    
}
