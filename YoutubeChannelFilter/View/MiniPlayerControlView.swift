//
//  MiniPlayerControlView.swift
//  YoutubeChannelFilter
//
//  Created by james on 12/13/23.
//

import UIKit
import SnapKit

protocol MiniPlayerViewDelegate: AnyObject {
    func handleExpandVideoPlayer()
    func handleDismissVideoPlayer()    
}

class MiniPlayerControlView: UIView {
            
    weak var miniPlayerDelegate: MiniPlayerViewDelegate?
    
//    private let baseView: UIView = {
//        let view = UIView()
//        return view
//    }()
    
    private let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "videoTitle"
        label.textColor = Color.black
        label.font = UIFont.systemFont(ofSize: 12.5)
        return label
    }()
    
    private let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "channelName"
        label.textColor = Color.black
        label.font = UIFont.systemFont(ofSize: 12.5)
        return label
    }()
    
    private lazy var cancelButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = Color.black
        button.setImage(button.createImage("xmark", weight: .thin), for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var playPauseButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.tintColor = Color.black
        button.setImage(button.createImage("pause.fill", weight: .thin), for: .normal)
        button.addTarget(self, action: #selector(didTapPausePlayButton), for: .primaryActionTriggered)
        return button
    }()
    
    private var isPlaying: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Color.background
        
//        self.addSubview(baseView)
//        baseView.addSubview(videoTitleLabel)
//        baseView.addSubview(channelNameLabel)
//        baseView.addSubview(pausePlayButton)
//        baseView.addSubview(cancelButton)
        addSubview(videoTitleLabel)
        addSubview(channelNameLabel)
        addSubview(playPauseButton)
        addSubview(cancelButton)
        
//        baseView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(self.safeAreaLayoutGuide)
//            make.trailing.equalTo(self.safeAreaLayoutGuide)
//            make.bottom.equalTo(self)
//        }
        
        videoTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(8)
            make.trailing.equalTo(playPauseButton.snp.leading)
            make.width.equalTo(150)
            
//            make.top.equalTo(baseView.snp.top).offset(10)
//            make.leading.equalTo(baseView).offset(8)
//            make.trailing.equalTo(pausePlayButton.snp.leading)
        }
        
        channelNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(videoTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(videoTitleLabel.snp.leading)
            make.trailing.equalTo(videoTitleLabel.snp.trailing)
            make.width.equalTo(150)
        }
        
        playPauseButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(cancelButton.snp.leading)
            make.width.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playPauseButton.snp.trailing)
            make.width.equalTo(50)
        }
        
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, 
                                                action: #selector(didTapExpandVideoPlayer))
        addGestureRecognizer(tapGesture)
    }
    
    func updatePlayButton(with imageName: String, isPlaying: Bool) {
        let image = playPauseButton.createImage(imageName)
        playPauseButton.setImage(image, for: .normal)
        self.isPlaying = isPlaying
    }
    
    func isHidden(_ hide: Bool) {
        alpha = hide ? 0 : 1
    }
    
    func configure(with data: VideoData) {
        //print(data.title)
        //print(data.channel)
        videoTitleLabel.text = data.title
        channelNameLabel.text = data.channel
    }
    
    @objc private func didTapPausePlayButton() {
        NotificationCenter.default.post(name: .didTapPlayPause,
                                        object: nil)
    }
    
    @objc private func didTapCancelButton() {
        miniPlayerDelegate?.handleDismissVideoPlayer()
    }
    
    @objc private func didTapExpandVideoPlayer() {
        miniPlayerDelegate?.handleExpandVideoPlayer()
    }
}
