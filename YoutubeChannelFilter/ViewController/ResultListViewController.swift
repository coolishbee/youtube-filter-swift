//
//  ResultListViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/30.
//

import UIKit

class ResultListViewController: UIViewController {
    
    private var videoArray = [VideoData]()
    private var searchWord : String = ""    
    
    lazy var backBtnImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.backward")
        view.tintColor = .darkGray
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var searchView: SearchView = {
        let view = SearchView()        
        view.addTarget(self, action: #selector(pushSearchView), for: .touchUpInside)
        return view
    }()
    
    lazy var resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupView()
        API.getYoutubeList(searchWord: searchWord) { result, error in
            guard let result = result else {
                print("Error! \(String(describing: error))")
                return
            }
            self.videoArray = result
            self.resultTableView.reloadData()
        }
    }
    
    init(word: String) {
        self.searchWord = word
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        //back button
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backVC(_:)))
        backBtnImageView.addGestureRecognizer(gesture)
        view.addSubview(backBtnImageView)
        backBtnImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.height.equalTo(30)
        }
        
        //search bar
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.leading.equalTo(backBtnImageView.snp.trailing).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        backBtnImageView.snp.makeConstraints { make in
            make.centerY.equalTo(searchView.snp.centerY)
        }
        searchView.configure(word: searchWord)
        
        //table view
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }        
    
    @objc private func backVC(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func pushSearchView() {
        let vc = SearchViewController()
        vc.searchWordDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
}

extension ResultListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.videoArray[indexPath.row].kind {
        case .Video:
            let cell = Bundle.main.loadNibNamed("VideoTableCell", owner: self, options: nil)?.first as! VideoTableCell
            cell.title.text = self.videoArray[indexPath.row].title
            cell.title.sizeToFit()
            cell.channel.text = self.videoArray[indexPath.row].channel
            cell.date.text = self.videoArray[indexPath.row].date
            let img = self.videoArray[indexPath.row].videoImg
            cell.videoImg.sd_setImage(with: URL(string: img), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            return cell
        case .Channel:
            let cell = Bundle.main.loadNibNamed("ChannelTableCell", owner: self, options: nil)?.first as! ChannelTableCell
            cell.channelTitle.text = self.videoArray[indexPath.row].channel
            let img = self.videoArray[indexPath.row].videoImg
            cell.channelImg.layer.cornerRadius = cell.channelImg.frame.height/2
            cell.channelImg.sd_setImage(with: URL(string: img), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            return cell
        case .PlayList:
            let cell = Bundle.main.loadNibNamed("PlayListTableCell", owner: self, options: nil)?.first as! PlayListTableCell
            cell.title.text = self.videoArray[indexPath.row].title
            cell.title.sizeToFit()
            cell.channel.text = self.videoArray[indexPath.row].channel
            cell.date.text = self.videoArray[indexPath.row].date
            let img = self.videoArray[indexPath.row].videoImg
            cell.videoImg.sd_setImage(with: URL(string: img), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
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

extension ResultListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print(self.videoArray[index].identifier ?? "id is empty")
        
        NotificationCenter.default.post(name: .openVideoPlayer, object: self.videoArray[index])
        
//        switch(indexPath.row){
//        case 0:
//            print("case 0")
//        case 1:
//            print("case 1")
//        default:
//            print("default")
//        }
    }
}

extension ResultListViewController: SearchWordDelegate {
    func sendQuery(query: String) {
        let resultListVC = ResultListViewController(word: query)
        self.navigationController?.pushViewController(resultListVC, animated: true)
    }
}
