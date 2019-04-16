//
//  TrackTableViewCell.swift
//  Spochify
//
//  Created by Alberto on 11/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    static let identifier = "TrackCell"
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        indexLabel.text = nil
        titleLabel.text = nil
        popularityLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func draw(index: Int, track: Track) {
        indexLabel.text = "\(index)"
        titleLabel.text = track.title
        popularityLabel.text = "\(track.popularity)/100"
    }
    
}
