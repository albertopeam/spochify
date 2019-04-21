//
//  SmallPlayerView.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIView

//TODO: add small player
class SmallPlayerView: UIView {
    
    init() {
//        let player = UIView(frame: CGRect.zero)
//        player.backgroundColor = .clear
//        player.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(player)
//        
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        player.insertSubview(blurView, at: 0)
//        
//        NSLayoutConstraint.activate([
//            player.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            player.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            player.heightAnchor.constraint(equalToConstant: 50),
//            player.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabBar.frame.height),
//            
//            blurView.heightAnchor.constraint(equalTo: player.heightAnchor),
//            blurView.widthAnchor.constraint(equalTo: player.widthAnchor)
//            ])
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
