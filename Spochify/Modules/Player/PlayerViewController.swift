//
//  PlayerViewController.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, BindableType {
    typealias ViewModelType = PlayerViewModel
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playingLabel: UILabel!
    @IBOutlet weak var playingProgress: UIProgressView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: PlayerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

}
