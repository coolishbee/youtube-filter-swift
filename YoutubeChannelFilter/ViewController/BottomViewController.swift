//
//  BottomViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/24.
//

import UIKit
import SnapKit

class BottomViewController: UIViewController {
    
    enum Design {
        static var rowHeight: CGFloat { return 54.0 }
    }
    
    private var tableViewHeightConstrants: NSLayoutConstraint?
    private var tableData = [BottomCellData]()
    
    lazy var dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.dim
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()    
    
    lazy var safeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = Design.rowHeight
        view.backgroundColor = Color.veryLightGrey
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isScrollEnabled = false
        view.register(BottomCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.safeView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: 0, height: 0)
        UIView.animate(withDuration: 0.33, animations: {
            self.safeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func dimGesture() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addAction(_ data: BottomCellData) {
        self.tableData.append(data)
    }
    
    private func setupView() {
        safeView.backgroundColor = Color.background
        contentView.backgroundColor = Color.background
        dimView.backgroundColor = Color.dim
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimGesture))
        dimView.addGestureRecognizer(tapGesture)
                
        view.addSubview(dimView)
        view.addSubview(safeView)
        safeView.addSubview(contentView)
        dimView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            } else {
//                make.bottom.equalTo(view.snp.bottom)
//            }
        }
        safeView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
                
        tableViewHeightConstrants = tableView.heightAnchor.constraint(equalToConstant: CGFloat(Int(Design.rowHeight) * self.tableData.count))
        tableViewHeightConstrants?.isActive = true
    }
}

extension BottomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let data = self.tableData[indexPath.row]
        data.handler()
    }
}

extension BottomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BottomCell else {
            return UITableViewCell()
        }
        let data = self.tableData[indexPath.row]
        cell.configure(data: data.cellData)
        return cell
    }
}
