//
//  PlayerViewController.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

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
    private let disposeBag = DisposeBag()
    
    var viewModel: PlayerViewModel!
    
    func bindViewModel() {
        //TODO: try to use scene coordinator
        closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
        
        viewModel.currentTrack()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (track) in
                guard let track = track else {
                    //TODO: no tracks???
                    return
                }
                self.playingLabel.text = track.title + " - " + track.album.name
                self.imageView.kf.setImage(with: track.album.image)
            }).disposed(by: disposeBag)
        
        viewModel.currentPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (playlist) in
                //TODO: maybe track album
                self.titleLabel.text = playlist.name
            }).disposed(by: disposeBag)
    }
    
    // MARK: private
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
