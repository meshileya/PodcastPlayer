//
//  PodCastPlayerView.swift
//  VideoPlayerWithXMLData
//
//  Created by TECHIES on 3/30/19.
//  Copyright © 2019 TECHIES. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import AVKit
import MediaPlayer

class PlayerDetailsView: CustomView, UIViewDialogProtocol {
    var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        avPlayer.volume = 1.0
        return avPlayer
    }()
    
    var videoData: Channel!{
        didSet{
            guard let url = URL(string: videoData?.image?[0].url ?? "") else { return }
            episodeImageView.kf.setImage(with: url)
            
            miniEpisodeImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, _, _, _) in
                let image = self.episodeImageView.image ?? UIImage()
                let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    return image
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
            }
        }
    }
    
    var episode: Item! {
        didSet {
            titleLabel.text = episode.title
            miniTitleLabel.text = episode.title
            setupNowPlayingInfo()
            
            playEpisode()
            guard let url = URL(string: videoData?.image?[0].url ?? "") else { return }
            episodeImageView.kf.setImage(with: url)
            
            miniEpisodeImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, _, _, _) in
                let image = self.episodeImageView.image ?? UIImage()
                let artworkItem = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    return image
                })
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = artworkItem
            }
           
        }
        
    }
    
func setupNowPlayingInfo() -> MPRemoteCommandHandlerStatus{
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.enclosure?._type
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    return .success
    }
    
func playEpisode() -> MPRemoteCommandHandlerStatus{
    guard let url = URL(string: episode.enclosure?._url ?? "") else { return .commandFailed }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    return .success
        
    }
    
func observePlayerCurrentTime() -> MPRemoteCommandHandlerStatus{
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let `self` = self else { return }
            self.currentTimeLabel.text = time.toDisplayString()
            print("TIMEEE")
            
            let durationTime = self.player.currentItem?.duration
            self.durationLabel.text = durationTime?.toDisplayString()
            self.updateCurrentTimeSlider()
        }
    return .success
    }
    
    fileprivate func updateCurrentTimeSlider() -> MPRemoteCommandHandlerStatus{
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
        return .success
    }
    
    fileprivate func setupAudioSession() -> MPRemoteCommandHandlerStatus{
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            return .success
        } catch let sessionErr {
            return .commandFailed
//            print("Failed to activate session:", sessionErr)
        }
    }
    /*
     @objc private func pause() -> MPRemoteCommandHandlerStatus {
         player?.pause()
         playButton.setImage(UIImage(named: "icon-play")?.alwaysTemplate, for: .normal)
         delegate?.playerViewDidPause()
         return .success
     }**/
    
    fileprivate func setupRemoteControl() -> MPRemoteCommandHandlerStatus {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handlePrevTrack))
        return .success
    }
    
    var playlistEpisodes = [Item]()
    
    @objc func handlePrevTrack() -> MPRemoteCommandHandlerStatus{
        if playlistEpisodes.isEmpty {
            return .commandFailed
        }
        
        let currentEpisodeIndex = playlistEpisodes.index { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.title == ep.title
        }
        guard let index = currentEpisodeIndex else { return .commandFailed }
        let prevEpisode: Item
        if index == 0 {
            let count = playlistEpisodes.count
            prevEpisode = (playlistEpisodes[count - 1])
        } else {
            prevEpisode = playlistEpisodes[index - 1]
        }
        self.episode = prevEpisode
        return .success
    }
    
    @objc func handleNextTrack() -> MPRemoteCommandHandlerStatus{
        if playlistEpisodes.count == 0 {
            return .commandFailed
        }
        
        let currentEpisodeIndex = playlistEpisodes.index { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.title == ep.title
        }
        
        guard let index = currentEpisodeIndex else { return .commandFailed}
        
        let nextEpisode: Item
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        } else {
            nextEpisode = playlistEpisodes[index + 1]
        }
        
        self.episode = nextEpisode
        return .success
    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }
    
    fileprivate func observeBoundaryTime() -> MPRemoteCommandHandlerStatus{
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            guard let `self` = self else { return}
            self.enlargeEpisodeImageView()
            self.setupLockscreenDuration()
        }
        return .success
        
    }
    
    fileprivate func setupLockscreenDuration() -> MPRemoteCommandHandlerStatus{
        guard let duration = player.currentItem?.duration else { return .commandFailed}
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        return .success
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    fileprivate func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification: Notification) -> MPRemoteCommandHandlerStatus{
        guard let userInfo = notification.userInfo else { return .commandFailed}
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return .commandFailed}
        if type == AVAudioSession.InterruptionType.began.rawValue {
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return .commandFailed }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
        }
        return .success
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }
    
    lazy var miniEpisodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_play_pod")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return imageView
    }()
    
    lazy var miniTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        return label
    }()
    
    lazy var miniPlayPauseButton : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    lazy var miniFastForwardButton : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleNextTrack), for: .touchUpInside)
        return button
    }()
    
    lazy var miniPlayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .launcherLightBackgroundColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minimizedStackView)
        view.layer.cornerRadius = 15
        view.sizeToFit()
        minimizedStackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        minimizedStackView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        minimizedStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        minimizedStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        return view
    }()
    
    lazy var minimizedStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.sizeToFit()
        view.distribution = .fillProportionally
        view.addArrangedSubview(miniEpisodeImageView)
        view.addArrangedSubview(miniTitleLabel)
        view.addArrangedSubview(miniPlayPauseButton)
        view.addArrangedSubview(miniFastForwardButton)
        
        return view
    }()
    
    lazy var maximizedStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 1
        view.sizeToFit()
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.setBackgroundColor(.white)
//        view.alignment = .
        view.addArrangedSubview(dismissLabel)
        view.addArrangedSubview(episodeImageView)
        view.addArrangedSubview(currentTimeSlider)
        view.addArrangedSubview(maximizedInnerStackView)
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(playerStackView)
        
        
        
        
        
        return view
    }()
    
    @IBAction func handleDismiss(_ sender: Any) {
        print("Dismmissssss clicked")
//        self.dismiss()
        self.miniPlayerView.isHidden = false
        self.maximizedStackView.isHidden = true
    }
    
    lazy var episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_play_pod")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.transform = shrunkenTransform
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return imageView
    }()
    
    lazy var currentTimeSlider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    lazy var maximizedInnerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.addArrangedSubview(currentTimeLabel)
        view.addArrangedSubview(dummyLabel)
        view.addArrangedSubview(dummyLabel2)
        view.addArrangedSubview(durationLabel)
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        return view
    }()
    
    lazy var dismissLabel : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 4;
        button.backgroundColor = .red
        button.setTitle("Minimize", for: .normal)
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Minimize"
        label.textAlignment = .center
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    lazy var dummyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    lazy var dummyLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 400).isActive = true
        label.text = "Title"
        label.font = UIFont(name: "Heiti TC", size: 13)
        return label
    }()
    
    lazy var playerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.addArrangedSubview(backwardButton)
        view.addArrangedSubview(playPauseButton)
        view.addArrangedSubview(forwardButton)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 400).isActive = true
        return view
    }()
    
    lazy var backwardButton : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(#imageLiteral(resourceName: "previous"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handlePrevTrack), for: .touchUpInside)
        return button
    }()
    
    lazy var playPauseButton : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    lazy var forwardButton : UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleNextTrack), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlayPause() -> MPRemoteCommandHandlerStatus{
        print("BUTTON PAUSE")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
            self.setupElapsedTime(playbackRate: 1)
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
            self.setupElapsedTime(playbackRate: 0)
        }
        return .success
    }
    
    func handleCurrentTimeSliderChange() -> MPRemoteCommandHandlerStatus{
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return .commandFailed}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        player.seek(to: seekTime)
        return .success
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
        setupRemoteControl()
        setupAudioSession()
        setupInterruptionObserver()
        observePlayerCurrentTime()
        observeBoundaryTime()
        handleCurrentTimeSliderChange()
        
       
//        if player.timeControlStatus == .playing {
//            player.pause()
//            //            btnPlay.setImage(UIImage(named: "control-play"), for: .normal)
//
//        }
        
    }
    
    func initViews(){
        sizeToFit()
        addSubview(maximizedStackView)
        addSubview(miniPlayerView)
        miniPlayerView.isHidden = true
        maximizedStackView.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        maximizedStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        maximizedStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        miniPlayerView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        miniPlayerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        miniPlayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        maximizedStackView.isUserInteractionEnabled = true
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
        
        
        maximizedInnerStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        isUserInteractionEnabled = true
        //        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        dismissLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dismissLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dismissLabel.isUserInteractionEnabled = true
        dismissLabel.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
