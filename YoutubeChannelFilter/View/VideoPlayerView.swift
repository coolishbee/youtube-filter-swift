//
//  VideoPlayerView.swift
//  YoutubeChannelFilter
//
//  Created by james on 12/13/23.
//

import UIKit
import SnapKit
import AVFoundation
import MaterialComponents.MaterialActivityIndicator

protocol VideoPlayerViewDelegate: AnyObject {
    func handleMinimizeVideoPlayer()
    func handleMaximizeVideoPlayer()
    func handleUpdateSlideBar(with progress: Float)
    func videoPlayStatusChanged(isPlaying: Bool)
}

class VideoPlayerView: UIView {
    
    enum Design {
        static var playButtonDimen: CGFloat { return 60.0 }
        static var skipButtonDimen: CGFloat { return 45.0 }
        static var buttonSpacing: CGFloat { return 35.0 }
    }
    
    weak var videoPlayerDelegate: VideoPlayerViewDelegate?
    var videoPlayerMode: VideoPlayerMode = .expand
        
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isScrubAble = false
    
    private(set) lazy var videoImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playbackSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.awakeFromNib()
        slider.alpha = 0
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.5)
//        slider.thumbTintColor = .red
//        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .normal)
//        slider.setThumbImage(#imageLiteral(resourceName: "thumb").withRenderingMode(.alwaysOriginal), for: .highlighted)
        slider.addTarget(self, action: #selector(handleSliderDragged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUpInside), for: .touchUpInside)
        return slider
    }()
    
    private lazy var playPauseButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.layer.cornerRadius = Design.playButtonDimen / 2
        button.alpha = 0
        button.setImage(button.createImage("pause.fill", imgSize: 30), for: .normal)
        button.addTarget(self, action: #selector(didTapPausePlayButton), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var skipBackwardButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.layer.cornerRadius = Design.skipButtonDimen / 2
        button.alpha = 0
        button.setImage(button.createImage("gobackward.5"), for: .normal)
        button.addTarget(self, action: #selector(didTapSkipBackwardsButton), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var skipForwardButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .black.withAlphaComponent(0.3)
        button.layer.cornerRadius = Design.skipButtonDimen / 2
        button.alpha = 0
        button.setImage(button.createImage("goforward.5"), for: .normal)
        button.addTarget(self, action: #selector(didTapSkipForwardsButton), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var fullScreenModeBtn: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.alpha = 0
        button.setImage(button.createImage("arrow.up.left.and.arrow.down.right", imgSize: 15), for: .normal)
        button.addTarget(self, action: #selector(didTapFullScreenModeButton), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var minimizeVideoPlayerBtn: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.alpha = 0
        button.setImage(button.createImage("chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(didTapMinimizePlayerButton), for: .primaryActionTriggered)
        return button
    }()
            
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.alpha = 0
        return label
    }()
    
    private(set) lazy var activityIndicator = MDCActivityIndicator()
        
    private var timeObserverToken: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction))
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(tapGesture)
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didTapPausePlayButton),
                                               name: .didTapPlayPause,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(videoImageView)
        addSubview(playbackSlider)
        addSubview(elapsedTimeLabel)
        
        addSubview(playPauseButton)
        addSubview(skipBackwardButton)
        addSubview(skipForwardButton)
        addSubview(minimizeVideoPlayerBtn)
        addSubview(fullScreenModeBtn)
        
        videoImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
                
        playbackSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.trailing.equalTo(self.snp.trailing)
        }
                
        elapsedTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        playPauseButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(Design.playButtonDimen)
        }
        
        skipBackwardButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(playPauseButton.snp.leading).offset(-Design.buttonSpacing)
            make.width.height.equalTo(Design.skipButtonDimen)
        }
                
        skipForwardButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playPauseButton.snp.trailing).offset(Design.buttonSpacing)
            make.width.height.equalTo(Design.skipButtonDimen)
        }
        
        minimizeVideoPlayerBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(Design.skipButtonDimen)
        }
        
        fullScreenModeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(elapsedTimeLabel.snp.centerY)
        }
        
        activityIndicator.sizeToFit()
        insertSubview(activityIndicator, belowSubview: playPauseButton)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    private func handleToggleControls() {
        [playPauseButton, skipBackwardButton, skipForwardButton, playbackSlider,
         elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn].forEach {
            view in UIView.animate(withDuration: 0.4, delay: 0) {[weak view] in
                guard let view = view else {
                    return
                }
                view.alpha = view.alpha == 0 ? 1 : 0
            }
        }
    }
    
    @objc func handleTapGestureAction() {
        switch videoPlayerMode {
        case .expand:
            guard isScrubAble else {
                return
            }
            handleToggleControls()
        case .minimize:
            videoPlayerDelegate?.handleMaximizeVideoPlayer()
        }
    }
    
    @objc func didTapPausePlayButton() {
        guard let player = player else 
        {
            return
        }
        if player.isPlaying {
            player.pause()
            videoPlayerDelegate?.videoPlayStatusChanged(isPlaying: false)
        } else {
            player.play()
            videoPlayerDelegate?.videoPlayStatusChanged(isPlaying: true)

        }
        playPauseButton.setImage(player.icon, for: .normal)
    }
    
    @objc func didTapSkipBackwardsButton() {
        print("didTapSkipBackwardsButton")
    }
    @objc func didTapSkipForwardsButton() {
        print("didTapSkipForwardsButton")
    }
    @objc func didTapFullScreenModeButton() {
        print("didTapFullScreenModeButton")
    }
    @objc func didTapMinimizePlayerButton() {
        videoPlayerDelegate?.handleMinimizeVideoPlayer()
    }
    
    func isHidden(_ hide: Bool) {
        
        [playPauseButton, skipBackwardButton, skipForwardButton, playbackSlider,
         elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn].forEach { view in
            view.isHidden = hide
        }
    }
    
    func playYoutube(for url: URL) {
        cleanUpPlayerForReuse()
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = .resizeAspectFill
        self.player = player
        self.playerLayer = playerLayer
        self.videoImageView.layer.addSublayer(playerLayer)
        self.player?.play()        
        setupPeriodicTimeObserver()
        
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(didPlayToEndTime(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        
        activityIndicator.stopAnimating()
    }
    
    private func setupPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.001,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = self.player?.addPeriodicTimeObserver(forInterval: interval, 
                                                                 queue: DispatchQueue.main,
                                                                 using: { [weak self] (elapsedTime) in
            self?.updateVideoPlayerState(with: elapsedTime)
        })
        
    }
    private func updateVideoPlayerState(with elapsedTime: CMTime) {
        let seconds = CMTimeGetSeconds(elapsedTime)
        guard let duration = player?.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duration)
        let progress = Float(seconds / durationSeconds)
        playbackSlider.value = progress
        videoPlayerDelegate?.handleUpdateSlideBar(with: progress)
                
        let totalDurationInSeconds = CMTimeGetSeconds(duration)
        let secondsString = String(format: "%02d", Int(seconds .truncatingRemainder(dividingBy: 60)))
        let minutesString = String(format: "%02d", Int(seconds) / 60)
        let currentTime = "\(minutesString):\(secondsString)"
        
        guard totalDurationInSeconds.isFinite else {
            return
        }
        
        let videoLength = String(format: "%02d:%02d",Int((totalDurationInSeconds / 60)),Int(totalDurationInSeconds) % 60)
        elapsedTimeLabel.text = currentTime + " / " + videoLength
    }
    
    @objc private func didPlayToEndTime(notification: Notification) {
        print("didPlayToEndTime")
    }
    
    @objc private func handleSliderDragged( sender: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(playbackSlider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        
        if player?.isPlaying == true {
            player?.pause()
        }
        
        player?.seek(to: seekTime)
    }
    
    @objc private func sliderTouchUpInside(sender: UISlider) {
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(playbackSlider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player?.seek(to: seekTime)
        player?.play()
    }
    
    func cleanUpPlayerForReuse()
    {
        prepareViewForReuse()
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: player?.currentItem)
        
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
            player?.replaceCurrentItem(with: nil)
            player = nil
            playerLayer = nil
            playbackSlider.value = 0
            isScrubAble = false
        }
    }
    
    //MARK: - Player Observer
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        if keyPath == "currentItem.loadedTimeRanges" {
            isScrubAble = true
        }
    }
    
    private func prepareViewForReuse() {
        let imageName = "pause.fill"
        let image = imageName.generateImage()
        playPauseButton.setImage(image, for: .normal)
        elapsedTimeLabel.text = ""
        
        [playPauseButton, skipBackwardButton, skipForwardButton,
         elapsedTimeLabel, fullScreenModeBtn, minimizeVideoPlayerBtn].forEach { view in
            view.alpha = 0
        }
    }
    
    
}
