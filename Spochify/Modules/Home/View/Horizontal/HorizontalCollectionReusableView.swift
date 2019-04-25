//
//  HorizontalCollectionReusableView.swift
//  Spochify
//
//  Created by Alberto on 25/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class HorizontalCollectionReusableView: UICollectionReusableView {

    static let identifier: String = "HorizontalCollectionReusableView"    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
