//
//  UICollectionView+FlowLayout.swift
//  Spochify
//
//  Created by Alberto on 13/05/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UICollectionView
import UIKit.UICollectionViewLayout

extension UICollectionView {
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
}


