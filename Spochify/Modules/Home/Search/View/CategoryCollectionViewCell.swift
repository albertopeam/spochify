//
//  CategoryCollectionViewCell.swift
//  Spochify
//
//  Created by Alberto on 15/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func draw(category: Category) {
        titleLabel.text = category.name
        imageView.kf.setImage(with: category.image)
    }

}
