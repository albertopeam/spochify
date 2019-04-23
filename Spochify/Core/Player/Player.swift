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

//TODO: Audio interruptions: TEST

class Player {
    
    private let avPlayer: AVPlayer
    private let notificationCenter: NotificationCenter
    private let systemPlayer: MPNowPlayingInfoCenter
    private let tracksSubject: ReplaySubject<Track>
    private let progressSubject: PublishSubject<Progress>
    private let playingSubject: BehaviorSubject<Bool>
    private var tracks: [Track]?
    private var current: Track?
    
    init(avPlayer: AVPlayer = AVPlayer(),
         avSession: AVAudioSession = AVAudioSession.sharedInstance(),
         notificationCenter: NotificationCenter = .default,
         systemPlayer: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.default(),
         tracksSubject: ReplaySubject<Track> = ReplaySubject.create(bufferSize: 1),
         progressSubject: PublishSubject<Progress> = PublishSubject(),
         playingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)) {
        self.avPlayer = avPlayer
        self.notificationCenter = notificationCenter
        self.systemPlayer = systemPlayer
        self.tracksSubject = tracksSubject
        self.progressSubject = progressSubject
        self.playingSubject = playingSubject
        self.notificationCenter.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: didUpdatedPlayer)
        try? avSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.allowBluetooth, .allowAirPlay, .defaultToSpeaker])
    }
    
    deinit {
        notificationCenter.removeObserver(self)
        avPlayer.removeTimeObserver(self)
    }
    
    // MARK: Player
    
    func playlist(with tracks: [Track]) {
        let newTracks = tracks.filter({ $0.url != nil })
        if let first = newTracks.first, let url = first.url {
            if !isPlaying() || self.tracks != newTracks {
                self.tracks = newTracks
                self.current = first
                self.tracksSubject.onNext(first)
                self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
            }
        }
    }
    
    lazy var play: Action<Void, Void> = Action {
        guard let track = self.current, let url = track.url else { return Observable.empty() }
        self.playNow(track: track)
        return Observable.empty()
    }
    
    lazy var pause: Action<Void, Void> = Action {
        self.pauseNow()
        return Observable.empty()
    }
    
    lazy var previous: Action<Void, Void> = Action {
        guard let previousTrack = self.previousTrack() else {
            self.current = nil
            return Observable.empty()
        }
        self.playNow(track: previousTrack)
        return Observable.empty()
    }
    
    lazy var next: Action<Void, Void> = Action {
        guard let nextTrack = self.nextTrack() else {
            self.current = nil
            return Observable.empty()
        }
        self.playNow(track: nextTrack)
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
    
    lazy var track: Observable<Track> = tracksSubject
        .asObservable()
        .share()
        .debug()
    
    // MARK: NotificationCenter
    
    @objc private func didPlayToEnd() {
        guard let nextTrack = nextTrack() else {
            self.current = nil
            return
        }
        playNow(track: nextTrack)
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
    
    private func playNow(track: Track) {
        guard let url = track.url else { return }
        if current != track {
            self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
        //todo: al salir y entrar reinicia la cancion al principio
        self.current = track
        self.tracksSubject.onNext(track)
        self.playingSubject.onNext(true)
        self.avPlayer.play()
        self.notificationCenter.addObserver(self, selector: #selector(self.didArriveInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        notifySystemPlayer(track: track)
    }
    
    private func pauseNow() {
        self.avPlayer.pause()
        self.playingSubject.onNext(false)
        self.notificationCenter.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    private func isPlaying() -> Bool {
        return avPlayer.rate > 0
    }
    
    private func notifySystemPlayer(track: Track) {
        let info: [String: Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.album.name,
            ]
        systemPlayer.nowPlayingInfo = info
    }
    
    // MARK: Interruptions
    
    @objc private func didArriveInterruption(notification: NSNotification) {
        if let value = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber,
            let type = AVAudioSession.InterruptionType(rawValue: value.uintValue){
            switch type {
            case .began:
                pause.execute()
            case .ended:
                play.execute()
            }
        }
    }
    
}

extension Player {
    struct Progress: Equatable {
        let duration: Float
        let current: Float
    }
}


