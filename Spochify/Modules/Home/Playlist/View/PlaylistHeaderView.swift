//
//  PlaylistHeaderView.swift
//  Spochify
//
//  Created by Alberto on 13/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import Action
import Kingfisher

class PlaylistHeaderView: UIView {
    
    enum ViewTraits {
        static let imageSize = CGSize(width: 150, height: 150)
        static let margin = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let titleHeight = CGFloat(21)
        static let buttonHeight = CGFloat(21)
        static let interItemSpace = CGFloat(8)
        static let height = ViewTraits.margin.top + ViewTraits.imageSize.height + ViewTraits.interItemSpace + ViewTraits.titleHeight + ViewTraits.interItemSpace + ViewTraits.buttonHeight + ViewTraits.margin.bottom
    }
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    var playButton: UIButton!

    init() {
        super.init(frame: CGRect.zero)
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        playButton = UIButton(type: UIButton.ButtonType.system)
        playButton.setTitleColor(UIColor.lightBlue, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle(String(localizedKey: String.Key.buttonPlay), for: UIControl.State.normal)
        addSubview(playButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewTraits.margin.top),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ViewTraits.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: ViewTraits.imageSize.height),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewTraits.interItemSpace),
            titleLabel.heightAnchor.constraint(equalToConstant: ViewTraits.titleHeight),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: ViewTraits.margin.left),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -ViewTraits.margin.right),
            
            playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.interItemSpace),
            playButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: ViewTraits.margin.left),
            playButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -ViewTraits.margin.right),
            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewTraits.margin.bottom)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(playlist: Playlist) {
        imageView.kf.setImage(with: playlist.image)
        titleLabel.text = playlist.name
    }

}
