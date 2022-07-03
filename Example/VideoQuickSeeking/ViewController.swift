//
//  ViewController.swift
//  ForwardRewindPlayerView
//
//  Created by Hai Pham on 05/03/2022.
//  Copyright (c) 2022 Hai Pham. All rights reserved.
//

import UIKit
import AVFoundation
import VideoQuickSeeking

class ViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var playerContainerView: UIView! {
        didSet {
            playerContainerView.backgroundColor = .clear
            let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
            singleTapGesture.numberOfTapsRequired = 1
            playerContainerView.addGestureRecognizer(singleTapGesture)
            
            let doubleTapGesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(doubleTap))
            doubleTapGesture.numberOfTapsRequired = 2
            playerContainerView.addGestureRecognizer(doubleTapGesture)
            
            singleTapGesture.require(toFail: doubleTapGesture)
        }
    }
    
    private lazy var avPlayer: AVPlayer = {
        let videoUrl = Bundle.main.url(forResource: "SampleVideo", withExtension: "mp4")
        let avPlayer = AVPlayer(url: videoUrl!)
        return avPlayer
    }()
    private lazy var avPlayerLayer: AVPlayerLayer = {
        let avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        return avPlayerLayer
    }()
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.tintColor = .white
            playButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var backdropView: UIView! {
        didSet {
            self.backdropView.alpha = 0
        }
    }
    
    private lazy var forwardRewindPlayerView: QuickSeekingView = {
        let view = QuickSeekingView(seekingDuration: self.seekingDuration)
        view.tintColor = .white
        return view
    }()
    
    private var isVideoPlaying = false {
        didSet {
            if self.isVideoPlaying {
                self.avPlayer.play()
                self.playButton.setImage(UIImage(named: "ic_pause")?.withRenderingMode(.alwaysTemplate),
                                         for: .normal)
            } else {
                self.avPlayer.pause()
                self.playButton.setImage(UIImage(named: "ic_play")?.withRenderingMode(.alwaysTemplate),
                                         for: .normal)
            }
        }
    }
    private let seekingDuration: Int = 10
    private var backdropTimer: Timer?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playerContainerView.layer.addSublayer(avPlayerLayer)
        self.playerContainerView.addSubview(self.forwardRewindPlayerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isVideoPlaying = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.forwardRewindPlayerView.frame = self.playerContainerView.bounds
        self.avPlayerLayer.frame = self.playerContainerView.bounds
    }
    
    // MARK: Private methods
    private func showVideoPlayer() {
        self.backdropView.alpha = 1
        self.backdropTimer?.invalidate()
        self.backdropTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
            UIView.animate(withDuration: 1) { [weak self] in
                self?.backdropView.alpha = 0
            }
        })
    }
}

// MARK: - Action selectors
extension ViewController {
    @objc func didTapPlayPause() {
        self.isVideoPlaying.toggle()
        self.showVideoPlayer()
    }
    
    @objc func singleTap() {
        print("Show player controller")
        self.showVideoPlayer()
    }
    
    @objc private func doubleTap(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: self.forwardRewindPlayerView)
        if let direction = self.forwardRewindPlayerView.directionOfPoint(point: point) {
            let newTime: Int64
            var shouldResetSeekingCounter = false
            switch direction {
            case .rewind:
                let rewindTime = Int(self.avPlayer.currentTime().seconds) - self.seekingDuration
                if rewindTime < 0 {
                    newTime = 0
                    shouldResetSeekingCounter = true
                } else {
                    newTime = Int64(rewindTime)
                }
            case .forward:
                let endTime = self.avPlayer.currentItem?.duration.seconds ?? 0
                let forwardTime = Int(self.avPlayer.currentTime().seconds) + self.seekingDuration
                if forwardTime > Int(endTime) {
                    newTime = Int64(forwardTime)
                    shouldResetSeekingCounter = true
                } else {
                    newTime = Int64(forwardTime)
                }
            }
            let targetTime = CMTimeMake(newTime, 1)
            self.avPlayer.seek(to: targetTime)
            
            self.forwardRewindPlayerView.animate(direction: direction,
                                                 at: point,
                                                 shouldResetSeekingCounter: shouldResetSeekingCounter)
        }
        print("rewindDoubleTap")
    }
    
    @objc private func rewindDoubleTap(_ sender: UIGestureRecognizer) {
        self.forwardRewindPlayerView.animate(direction: .rewind,
                                             at: sender.location(in: self.forwardRewindPlayerView))
        print("rewindDoubleTap")
    }
    
    @objc private func forwardDoubleTap(_ sender: UIGestureRecognizer) {
        self.forwardRewindPlayerView.animate(direction: .forward,
                                             at: sender.location(in: self.forwardRewindPlayerView))
        print("forwardDoubleTap")
    }
}
