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
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private let disposeBag = DisposeBag()
    var viewModel: PlayerViewModel!
    
    func bindViewModel() {
        //TODO: the subscriptions done in this method apparently are not doing good UI, `viewModel.playing` test it, it is not showing correctly the play/pause button if both of them are visible, now pause is hidden.
        viewModel.currentPlaylist
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (playlist) in
                self.titleLabel.text = playlist.name
            })
            .disposed(by: disposeBag)
        
        viewModel.track
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (track) in
                self.playingLabel.text = track.title + " - " + track.album.name
                self.imageView.kf.setImage(with: track.album.image)
            })
            .disposed(by: disposeBag)
        
        viewModel.playing
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (playing) in
                if playing {
                    self.playButton.isHidden = true
                    self.pauseButton.isHidden = false
                } else {
                    self.pauseButton.isHidden = true
                    self.playButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.progress
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (progress) in
                self.playingProgress.setProgress(progress.current/progress.duration, animated: false)
            })
            .disposed(by: disposeBag)
        
        playButton.rx.action = viewModel.playAction
        pauseButton.rx.action = viewModel.pauseAction
        previousButton.rx.action = viewModel.previousAction
        nextButton.rx.action = viewModel.nextAction
        
        //TODO: try to use scene coordinator
        //closeButton.rx.action = viewModel.closeAction
        closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: private
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
