//
//  MainTabBarVC.swift
//  YoutubeChannelFilter
//
//  Created by james on 12/15/23.
//

import UIKit
import YouTubeKit
import SnapKit

class MainTabBarVC: UITabBarController {
    
    private lazy var videoPlayerView: VideoPlayerView = {
        let view = VideoPlayerView()
        view.videoPlayerDelegate = self
        return view
    }()
    
    private lazy var miniPlayerControlView: MiniPlayerControlView = {
        let view = MiniPlayerControlView()
        view.miniPlayerDelegate = self
        return view
    }()
    
    private let videoPlayerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let detailsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.background
        return view
    }()
    
    private let playbackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.5)
        slider.thumbTintColor = .red
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .normal)
        slider.setThumbImage( UIImage().withRenderingMode(.alwaysTemplate), for: .highlighted)
        slider.isHidden = true
        return slider
    }()
    
    private var isTabBarHidden = false {
        didSet {
            //print(isTabBarHidden)
            playbackSlider.isHidden = isTabBarHidden
        }
    }
    
    private var videoPlayerMode: VideoPlayerMode = .expand {
        didSet {
            videoPlayerView.videoPlayerMode = videoPlayerMode
        }
    }
    
    lazy var myPageController = handleCreateTab(with: MyPageViewController(),
                                                title: "You",
                                                selectedImg: UIImage(named: "me_1"),
                                                image: UIImage(named: "me"))
    
    lazy var shortsController = handleCreateTab(with: UIViewController(),
                                                title: "Shorts",
                                                selectedImg: UIImage(systemName: "flame.fill"),
                                                image: UIImage(systemName: "flame"))
    
    lazy var subsController = handleCreateTab(with: SubsViewController(),
                                              title: "Subscribe",
                                              selectedImg: UIImage(systemName: "play.square.stack.fill"),
                                              image: UIImage(systemName: "play.square.stack"))
    
    private var videoPlayerContainerViewTopAnchor = NSLayoutConstraint()
    
    private var videoPlayerViewWidthAnchor = NSLayoutConstraint() //videoplayer size
    private var videoPlayerViewHeightAnchor = NSLayoutConstraint() //hieght size
    private let videoPlayerMaxHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16
    private let videoPlayerMaxWidth: CGFloat = UIScreen.main.bounds.width

    private lazy var statusBarHeight = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
    private lazy var calcMiniPlayerHeight = tabBar.frame.height + MINI_PLAYER_HEIGHT + statusBarHeight
    private lazy var miniPlayerPadding: CGFloat = UIScreen.main.bounds.height - calcMiniPlayerHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupView()
        setupPlayerView()
        setupTabBarAppearance()
        setupGesture()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOpenVideoPlayer),
                                               name: .openVideoPlayer,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isTabBarHidden {
            let offset = tabBar.frame.height
            let tabBar = tabBar
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: offset)
        }
    }
    
    private func setupView() {
        let homeVC = HomeViewController()
        let homeNC = handleCreateTab(with: homeVC,
                                     title: "Home",
                                     selectedImg: UIImage(named: "home_1"),
                                     image: UIImage(named: "home"))
        
        //setViewControllers([homeNC, libraryController], animated: true)
        //viewControllers = [subsController, homeNC, shortsController, myPageController]
        viewControllers = [homeNC, subsController, shortsController, myPageController]
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.black]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.black]
        tabBarItemAppearance.normal.iconColor = Color.black
        //tabBarAppearance.backgroundColor = Color.background
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        //tabBar.barTintColor = APP_BACKGROUND_COLOR
        //tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        videoPlayerContainerView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandVideoPlayer))
        videoPlayerView.addGestureRecognizer(tapGesture)
    }
    
    private func handleCreateTab(with vc: UIViewController, 
                                 title: String?,
                                 selectedImg: UIImage?,
                                 image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImg
        tabBar.unselectedItemTintColor = Color.black
        tabBar.tintColor = Color.black
        return navController
    }
    
    func setupPlayerView() {
        view.insertSubview(videoPlayerContainerView, belowSubview: tabBar)
        
        videoPlayerContainerView.addSubview(detailsContainerView)
        videoPlayerContainerView.addSubview(videoPlayerView)
        videoPlayerContainerView.addSubview(miniPlayerControlView)
        videoPlayerContainerView.addSubview(playbackSlider)

        videoPlayerContainerView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(view.frame.height)
        }
        
        videoPlayerView.snp.makeConstraints { (make) in
//            make.top.equalTo(videoPlayerContainerView.snp.top)
//            make.leading.equalTo(videoPlayerContainerView.snp.leading)
            make.top.leading.equalTo(videoPlayerContainerView)
        }
        
        miniPlayerControlView.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayerView.snp.top)
            make.leading.equalTo(videoPlayerView.snp.trailing)
            make.bottom.equalTo(videoPlayerView.snp.bottom)
            make.trailing.equalTo(videoPlayerContainerView.snp.trailing)
        }

        detailsContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(videoPlayerView.snp.bottom)
            make.leading.equalTo(videoPlayerContainerView.snp.leading)
            make.bottom.equalTo(videoPlayerContainerView.snp.bottom)
            make.trailing.equalTo(videoPlayerContainerView.snp.trailing)
        }
        
        playbackSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(tabBar.snp.leading)
            make.bottom.equalTo(tabBar.snp.top)
            make.trailing.equalTo(tabBar.snp.trailing)
        }
        
        videoPlayerContainerViewTopAnchor = videoPlayerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, 
                                                                                          constant: view.frame.height)
        videoPlayerContainerViewTopAnchor.isActive = true
        
        videoPlayerViewHeightAnchor = videoPlayerView.heightAnchor.constraint(equalToConstant: videoPlayerMaxHeight)
        videoPlayerViewHeightAnchor.isActive = true
        
        videoPlayerViewWidthAnchor = videoPlayerView.widthAnchor.constraint(equalToConstant: videoPlayerMaxWidth)
        videoPlayerViewWidthAnchor.isActive = true
    }
    
    @objc private func expandVideoPlayer() {
        videoPlayerView.isHidden(false)
        isTabBarHidden = true
        videoPlayerContainerViewTopAnchor.constant = 0
        videoPlayerViewHeightAnchor.constant = videoPlayerMaxHeight
        maximizeVideoPlayerViewWidth()
        videoPlayerMode = .expand
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func minimizeVideoPlayer() {
        videoPlayerView.isHidden(true)
        isTabBarHidden = false
        videoPlayerContainerViewTopAnchor.constant = miniPlayerPadding
        videoPlayerViewHeightAnchor.constant = MINI_PLAYER_HEIGHT
        minimizeVideoPlayerViewWidth()
        videoPlayerMode = .minimize
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseIn) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func dragVideoPlayerContainerView(to yPoint: CGFloat) {
        if videoPlayerContainerViewTopAnchor.constant == 0 && yPoint < 0 {
            return
        }
        videoPlayerContainerViewTopAnchor.constant += yPoint
    }
    
    private func increaseVideoPlayerViewHeight() {
        if videoPlayerViewHeightAnchor.constant < videoPlayerMaxHeight {
            videoPlayerViewHeightAnchor.constant += 2
        }
    }
    
    private func decreaseVideoPlayerViewHeight() {
        let heightLimit: CGFloat = 100
        if videoPlayerViewHeightAnchor.constant > heightLimit {
            videoPlayerViewHeightAnchor.constant -= 1
        }
    }
    
    private func maximizeVideoPlayerViewWidth() {
        
        miniPlayerControlView.isHidden(true)
        
        if videoPlayerViewWidthAnchor.constant < videoPlayerMaxWidth {
                        
            videoPlayerViewWidthAnchor.constant = videoPlayerMaxWidth
            
            UIView.animate(withDuration: 0.5, 
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseIn) {[ weak view] in
                view?.layoutIfNeeded()
            }
            
        }
    }
    
    private func minimizeVideoPlayerViewWidth() {
        
        miniPlayerControlView.isHidden(false)

        if videoPlayerViewWidthAnchor.constant == videoPlayerMaxWidth {
            
            videoPlayerViewWidthAnchor.constant = MINI_PLAYER_WIDTH
            
            UIView.animate(withDuration: 0.4, 
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: view)
            dragVideoPlayerContainerView(to: translation.y)
            
            videoPlayerView.isHidden(true)
            playbackSlider.isHidden = true

            switch sender.direction(in: view) {
            case .up:
                increaseVideoPlayerViewHeight()
                maximizeVideoPlayerViewWidth()
            case .down:
                decreaseVideoPlayerViewHeight()
            default:
                break
            }
            sender.setTranslation(.zero, in: view)
            
        case .failed, .cancelled, .ended:
            videoPlayerMode = sender.direction(in: view) == .down ? .minimize : .expand
            onGestureCompletion(mode: videoPlayerMode)
        default:
            break
        }
    }
    
    private func onGestureCompletion(mode: VideoPlayerMode) {
        switch mode {
        case .expand:
            expandVideoPlayer()
        case .minimize:
            minimizeVideoPlayer()
        }
    }
    
    @objc func handleOpenVideoPlayer(_ sender: Notification) {
        guard let data = sender.object as? VideoData else {
            return
        }
        guard let videoId = data.identifier else {
            return
        }
        
        miniPlayerControlView.configure(with: data)
        
        videoPlayerView.cleanUpPlayerForReuse()
        videoPlayerView.videoImageView.sd_setImage(with: URL(string: data.videoImg))
        videoPlayerView.activityIndicator.startAnimating()
        expandVideoPlayer()
        
        Task{
            do {
                let stream = try await YouTube(videoID: videoId).streams
                    .filterVideoAndAudio()
                    .filter { $0.isNativelyPlayable }
                    .highestResolutionStream()
                guard let url = stream?.url else {
                    print("streaming url nil")
                    return
                }
                self.videoPlayerView.playYoutube(for: url)
                
                if let update = RealmManager.shared.load(VideoDataRecord.self,
                                                         key: "identifier",
                                                         value: videoId)
                    .first{ RealmManager.shared.write {
                        update.date = Date()
                    }
                }else{
                    RealmManager.shared.add(VideoDataRecord(title: data.title,
                                                            channel: data.channel,
                                                            url: data.videoImg,
                                                            id: videoId,
                                                            type: VideoSaveType.RecentRecord.rawValue))
                }
            } catch {
                print("streaming failed")
            }
        }
    }
}

extension MainTabBarVC: VideoPlayerViewDelegate {
    func handleMinimizeVideoPlayer() {
        minimizeVideoPlayer()
    }
    
    func handleMaximizeVideoPlayer() {
        expandVideoPlayer()
    }
    
    func handleUpdateSlideBar(with progress: Float) {
        playbackSlider.value = progress
    }
    
    func videoPlayStatusChanged(isPlaying: Bool) {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        miniPlayerControlView.updatePlayButton(with: imageName, isPlaying: isPlaying)
    }
}

extension MainTabBarVC: MiniPlayerViewDelegate {
    func handleExpandVideoPlayer() {
        expandVideoPlayer()
    }
    
    func handleDismissVideoPlayer() {
        videoPlayerView.cleanUpPlayerForReuse()
        videoPlayerContainerViewTopAnchor.constant = view.frame.height
        
        playbackSlider.isHidden = true
        playbackSlider.value = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }        
}
