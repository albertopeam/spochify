//
//  PlaylistCollectionViewCell.swift
//  Spochify
//
//  Created by Alberto on 10/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import Kingfisher

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaylistCell"

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
    
    func draw(playlist: Playlist) {
        titleLabel.text = playlist.name
        imageView.kf.setImage(with: playlist.image)
    }

}
