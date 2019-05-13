//
//  SmallPlayerView.swift
//  Spochify
//
//  Created by Alberto on 16/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit.UIView
import RxSwift
import Kingfisher

class MiniPlayerView: UIView, BindableType {
    typealias ViewModelType = MiniPlayerViewModel
    
    private let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    private let titleLabel: UILabel = UILabel(frame: CGRect.zero)
    private let playingProgress: UIProgressView = UIProgressView(frame: CGRect.zero)
    private var playButton: UIButton = UIButton(type: UIButton.ButtonType.system)
    private var pauseButton: UIButton = UIButton(type: UIButton.ButtonType.system)
    private let disposeBag = DisposeBag()
    private var heightConstraint: NSLayoutConstraint!
    var viewModel: MiniPlayerViewModel!
    
    enum ViewTraits {
        static let height: CGFloat = 50
        static let imageSide: CGFloat = ViewTraits.height - ViewTraits.height / 5
        static let margin: CGFloat = 8
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurView, at: 0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        
        playingProgress.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playingProgress)
        
        playButton.setImage(UIImage(named: "outline_play_circle_filled_black_36pt"), for: UIControl.State.normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        
        pauseButton.setImage(UIImage(named: "outline_pause_circle_filled_black_36pt"), for: UIControl.State.normal)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pauseButton)
        
        heightConstraint = blurView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightConstraint,
            
            playingProgress.leadingAnchor.constraint(equalTo: leadingAnchor),
            playingProgress.trailingAnchor.constraint(equalTo: trailingAnchor),
            playingProgress.topAnchor.constraint(equalTo: topAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.margin),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ViewTraits.imageSide),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: ViewTraits.margin),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -ViewTraits.margin),
            
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.margin),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: ViewTraits.imageSide),
            playButton.widthAnchor.constraint(equalToConstant: ViewTraits.imageSide),
            
            pauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.margin),
            pauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pauseButton.heightAnchor.constraint(equalToConstant: ViewTraits.imageSide),
            pauseButton.widthAnchor.constraint(equalToConstant: ViewTraits.imageSide)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        viewModel.currentTrack
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (track) in
                self.titleLabel.text = track.title + " - " + track.album.name
                self.imageView.kf.setImage(with: track.album.image)
            })
            .disposed(by: disposeBag)
        viewModel.playing
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (isPlaying) in self.configurePlayButton(isPlaying: isPlaying)})
            .disposed(by: disposeBag)
        viewModel.currentProgress
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (progress) in self.playingProgress.setProgress(progress.current/progress.duration, animated: false) })
            .disposed(by: disposeBag)
        
        playButton.rx.action = viewModel.playAction
        pauseButton.rx.action = viewModel.pauseAction
    }
    
    // MARK: private
    
    private func configurePlayButton(isPlaying: Bool) {
        if isPlaying {
            self.heightConstraint.constant = ViewTraits.height
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
            self.layoutIfNeeded()
        } else {
            self.pauseButton.isHidden = true
            self.playButton.isHidden = false
        }
    }
}
