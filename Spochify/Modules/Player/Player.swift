//
//  Player.swift
//  Spochify
//
//  Created by Alberto on 19/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift
import Action

//TODO: entering/connecting doesn't start reproducing if it is reproducing..
//TODO: permiso bg
//TODO: set stream(revisar video udemy) de audio
//TODO: controles nativos + UI nativa
//TODO: Audio interruptions

class Player {
    
    private var avPlayer: AVPlayer
    private let notificationCenter: NotificationCenter
    private let tracksSubject: ReplaySubject<Track>
    private let progressSubject: PublishSubject<Progress>
    private let playingSubject: ReplaySubject<Bool>
    private var tracks: [Track]?
    private var current: Track?
    
    init(avPlayer: AVPlayer = AVPlayer(),
         notificationCenter: NotificationCenter = .default,
         tracksSubject: ReplaySubject<Track> = ReplaySubject.create(bufferSize: 1),
         progressSubject: PublishSubject<Progress> = PublishSubject(),
         playingSubject: ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)) {
        self.avPlayer = avPlayer
        self.notificationCenter = notificationCenter
        self.tracksSubject = tracksSubject
        self.progressSubject = progressSubject
        self.playingSubject = playingSubject
        self.notificationCenter.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: didUpdatedPlayer)
    }
    
    //T
    deinit {
        notificationCenter.removeObserver(self)
        avPlayer.removeTimeObserver(self)
    }
    
    // MARK: Player
    
    func tracks(tracks: [Track]) -> Observable<Track> {
        self.tracks = tracks.filter({ $0.url != nil })
        if let first = self.tracks?.first {
            play(track: first)
        }
        return tracksSubject
            .asObservable()
            .share()
            .debug()
    }
    
    lazy var play: Action<Void, Void> = Action {
        guard let track = self.current, let url = track.url else { return Observable.empty() }
        self.avPlayer.play()
        self.playingSubject.onNext(true)
        return Observable.empty()
    }
    
    lazy var pause: Action<Void, Void> = Action {
        self.avPlayer.pause()
        self.playingSubject.onNext(false)
        return Observable.empty()
    }
    
    lazy var previous: Action<Void, Void> = Action {
        guard let previousTrack = self.previousTrack() else {
            self.current = nil
            return Observable.empty()
        }
        self.play(track: previousTrack)
        return Observable.empty()
    }
    
    lazy var next: Action<Void, Void> = Action {
        guard let nextTrack = self.nextTrack() else {
            self.current = nil
            return Observable.empty()
        }
        self.play(track: nextTrack)
        return Observable.empty()
    }
    
    lazy var progress: Observable<Progress> = progressSubject
        .asObservable()
        .share()
        .debug()
    
    lazy var playing: Observable<Bool> = playingSubject
        .asObservable()
        .share()
        .debug()
    
    // MARK: NotificationCenter
    
    @objc private func didPlayToEnd() {
        guard let nextTrack = nextTrack() else {
            self.current = nil
            return
        }
        play(track: nextTrack)
    }
    
    // MARK: Player
    
    @objc private func didUpdatedPlayer(time: CMTime) {
        guard let playerDuration = avPlayer.currentItem?.duration else { return }
        let duration = Float(CMTimeGetSeconds(playerDuration))
        let currentTime = Float(CMTimeGetSeconds(time))
        let progress = Progress(duration: duration, current: currentTime)
        progressSubject.onNext(progress)
    }
    
    // MARK: Private
    
    private func previousTrack() -> Track? {
        guard let current = self.current else { return nil }
        guard let curIndex = tracks?.firstIndex(of: current) else { return nil }
        let target = curIndex - 1
        guard target >= 0 else { return self.current }
        return tracks?[target]
    }
    
    private func nextTrack() -> Track? {
        guard let current = self.current else { return nil }
        guard let curIndex = tracks?.firstIndex(of: current) else { return nil }
        let target = curIndex + 1
        guard target < self.tracks?.count ?? 0 else { return nil }
        return tracks?[target]
    }
    
    private func play(track: Track) {
        guard let url = track.url else { return }
        self.current = track
        self.tracksSubject.onNext(track)
        self.playingSubject.onNext(true)
        self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.avPlayer.play()
    }
    
}

extension Player {
    struct Progress: Equatable {
        let duration: Float
        let current: Float
    }
}
