//
//  AlbumCollectionViewCell.swift
//  Spochify
//
//  Created by Alberto on 25/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func draw(album: Album) {
        backgroundColor = .red
    }

}
