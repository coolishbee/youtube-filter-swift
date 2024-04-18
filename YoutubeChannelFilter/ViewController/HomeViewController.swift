//
//  HomeViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/03.
//

import UIKit
import Alamofire
import SDWebImage
import SnapKit
import RealmSwift

class HomeViewController: UIViewController {
    private var videoArray = [VideoData]()
    
    lazy var videoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPress)
        return tableView
    }()
    
    private let logImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "youtubeLogo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(searchViewBtn(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var chromeCastButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "broadcast"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        API.getYoutubeList(searchWord: "플러터") { result, error in
            guard let result = result else {
                print("Error! \(String(describing: error))")
                return
            }
            self.videoArray = result
            self.videoTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
                
        view.addSubview(logImageView)
        logImageView.snp.makeConstraints { imageView in
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(-10)
            imageView.height.equalTo(20)
        }

        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { btn in
            btn.top.equalTo(view.safeAreaLayoutGuide)
            btn.trailing.equalTo(view.safeAreaLayoutGuide)
            btn.width.height.equalTo(50)
        }
        
        view.addSubview(chromeCastButton)
        chromeCastButton.snp.makeConstraints { btn in
            btn.top.equalTo(view.safeAreaLayoutGuide)
            btn.trailing.equalTo(searchButton.snp.leading)
            btn.width.height.equalTo(50)
        }
                
        view.addSubview(videoTableView)
        videoTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(logImageView.snp.bottom).offset(10)
            tableView.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func searchViewBtn(_ sender: UIButton) {
        let vc = SearchViewController()
        vc.searchWordDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: videoTableView)
            if let indexPath = videoTableView.indexPathForRow(at: touchPoint) {
                let index = indexPath.row                
                let bottomVC = BottomViewController(title: "설정")
                bottomVC.addAction(BottomCellData(cellData: BottomCellData.channelBlock, handler: {
                    
                    if let update = RealmManager.shared.load(VideoDataRecord.self,
                                                             key: "identifier",
                                                             value: self.videoArray[index].identifier ?? "")
                        .first{ RealmManager.shared.write {
                            update.date = Date()
                        }
                    }else{
                        RealmManager.shared.add(VideoDataRecord(title: self.videoArray[index].title,
                                                                channel: self.videoArray[index].channel,
                                                                url: self.videoArray[index].videoImg,
                                                                id: self.videoArray[index].identifier ?? "",
                                                                type: VideoSaveType.ChannelBlock.rawValue))
                    }
                    
                }))
                bottomVC.addAction(BottomCellData(cellData: BottomCellData.saveChannel, handler: {
                    if let update = RealmManager.shared.load(VideoDataRecord.self,
                                                             key: "identifier",
                                                             value: self.videoArray[index].identifier ?? "")
                        .first{ RealmManager.shared.write {
                            update.date = Date()
                        }
                    }else{
                        RealmManager.shared.add(VideoDataRecord(title: self.videoArray[index].title,
                                                                channel: self.videoArray[index].channel,
                                                                url: self.videoArray[index].videoImg,
                                                                id: self.videoArray[index].identifier ?? "",
                                                                type: VideoSaveType.SaveChannel.rawValue))
                    }
                }))
                bottomVC.addAction(BottomCellData(cellData: BottomCellData.videoBlock, handler: {
                    if let update = RealmManager.shared.load(VideoDataRecord.self,
                                                             key: "identifier",
                                                             value: self.videoArray[index].identifier ?? "")
                        .first{ RealmManager.shared.write {
                            update.date = Date()
                        }
                    }else{
                        RealmManager.shared.add(VideoDataRecord(title: self.videoArray[index].title,
                                                                channel: self.videoArray[index].channel,
                                                                url: self.videoArray[index].videoImg,
                                                                id: self.videoArray[index].identifier ?? "",
                                                                type: VideoSaveType.VideoBlock.rawValue))
                    }
                }))
                bottomVC.addAction(BottomCellData(cellData: BottomCellData.saveVideo, handler: {
                    if let update = RealmManager.shared.load(VideoDataRecord.self,
                                                             key: "identifier",
                                                             value: self.videoArray[index].identifier ?? "")
                        .first{ RealmManager.shared.write {
                            update.date = Date()
                        }
                    }else{
                        RealmManager.shared.add(VideoDataRecord(title: self.videoArray[index].title,
                                                                channel: self.videoArray[index].channel,
                                                                url: self.videoArray[index].videoImg,
                                                                id: self.videoArray[index].identifier ?? "",
                                                                type: VideoSaveType.SaveVideo.rawValue))
                    }
                }))
                present(bottomVC, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("tableView " + String(indexPath.row))
        
        switch self.videoArray[indexPath.row].kind {
        case .Video:
            let cell = Bundle.main.loadNibNamed("VideoTableCell", 
                                                owner: self,
                                                options: nil)?.first as! VideoTableCell
            cell.title.text = self.videoArray[indexPath.row].title
            cell.title.sizeToFit()
            cell.channel.text = self.videoArray[indexPath.row].channel
            cell.date.text = self.videoArray[indexPath.row].date
            let img = self.videoArray[indexPath.row].videoImg
            cell.videoImg.sd_setImage(with: URL(string: img), 
                                      placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            return cell
        case .Channel:
            let cell = Bundle.main.loadNibNamed("ChannelTableCell", 
                                                owner: self,
                                                options: nil)?.first as! ChannelTableCell
            cell.channelTitle.text = self.videoArray[indexPath.row].channel
            let img = self.videoArray[indexPath.row].videoImg
            cell.channelImg.layer.cornerRadius = cell.channelImg.frame.height/2
            cell.channelImg.sd_setImage(with: URL(string: img), 
                                        placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            return cell
        case .PlayList:
            let cell = Bundle.main.loadNibNamed("PlayListTableCell", 
                                                owner: self,
                                                options: nil)?.first as! PlayListTableCell
            cell.title.text = self.videoArray[indexPath.row].title
            cell.title.sizeToFit()
            cell.channel.text = self.videoArray[indexPath.row].channel
            cell.date.text = self.videoArray[indexPath.row].date
            let img = self.videoArray[indexPath.row].videoImg
            cell.videoImg.sd_setImage(with: URL(string: img), 
                                      placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = indexPath.row
        if(self.videoArray[type].kind == .Channel) {
            return 155
        }else {
            return 310
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //print("User Selected: ", String(index))
        print(self.videoArray[index].identifier ?? "id is empty")
                        
        NotificationCenter.default.post(name: .openVideoPlayer, object: self.videoArray[index])
        
//        if #available(iOS 15.0, *) {
//            if let sheet = bottomVC.sheetPresentationController {
//                sheet.detents = [.medium(), .large()]
//                sheet.largestUndimmedDetentIdentifier = .large
//                sheet.prefersGrabberVisible = true
//            }
//        } else {
//            // Fallback
//        }
                
//        present(bottomVC, animated: true, completion: nil)
    }
}

extension HomeViewController: SearchWordDelegate {
    func sendQuery(query: String) {        
        let resultListVC = ResultListViewController(word: query)
        self.navigationController?.pushViewController(resultListVC, animated: true)
    }
}
