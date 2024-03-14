//
//  SearchViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/28.
//

import UIKit
import SnapKit
import RealmSwift
//import RxSwift
//import RxCocoa
import Combine
import CombineCocoa

protocol SearchWordDelegate: AnyObject {
    func sendQuery(query: String)
}

final class SearchViewController: UIViewController {
    private var records = [SearchRecord]()
    //private var disposeBag = DisposeBag()
    private var subscriptions = Set<AnyCancellable>()
    weak var searchWordDelegate: SearchWordDelegate?
    
    lazy var backBtnImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.backward")
        view.tintColor = .darkGray
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popView(_:))))
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "YouTube 검색"
        //bar.delegate = self
        bar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        bar.becomeFirstResponder()
        return bar
    }()
    
    lazy var searchRecordTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchRecordCell.self,
                           forCellReuseIdentifier: SearchRecordCell.reuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "searchRecordTableHeaderView")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindRx()
        fetchRecords()
        searchRecordTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {        
        view.backgroundColor = .systemBackground
        view.addSubview(backBtnImageView)
        view.addSubview(searchBar)
        view.addSubview(searchRecordTableView)
        
        backBtnImageView.snp.makeConstraints { imageView in
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.width.height.equalTo(30)
        }
        
        searchBar.snp.makeConstraints { searchBar in
            searchBar.leading.equalTo(backBtnImageView.snp.trailing)
            searchBar.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        backBtnImageView.snp.makeConstraints { imageView in
            imageView.centerY.equalTo(searchBar.snp.centerY)
        }
        
        searchRecordTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(searchBar.snp.bottom)
            tableView.leading.trailing.bottom.equalTo(view)
        }
    }
    
    private func bindRx() {
//        searchBar.rx.text
//            .orEmpty
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] (str) in
//                guard let self = self else {
//                    return
//                }
//                if(str.isEmpty) {
//                    print("str is empty")
//                    self.fetchRecords()
//                }else{
//                    print(str)
//                    let word = str.trimmingCharacters(in: .whitespaces)
//                    
//                    self.records = Array(try! Realm()
//                        .objects(SearchRecord.self)
//                        .filter(NSPredicate(format: "title CONTAINS %@", word))
//                        //.filter("title CONTAINS[cd] %@", str)
//                        .sorted(byKeyPath: "date", ascending: false))
//                }
//                
//                self.searchRecordTableView.reloadData()
//            }).disposed(by: disposeBag)
        
        searchBar.textDidChangePublisher
            .sink(receiveValue: {
                if ($0.isEmpty) {
                    self.fetchRecords()
                }else{
                    let word = $0.trimmingCharacters(in: .whitespaces)
                    
                    self.records = Array(try! Realm()
                        .objects(SearchRecord.self)
                        .filter(NSPredicate(format: "title CONTAINS %@", word))
                        .sorted(byKeyPath: "date", ascending: false))
                }
                self.searchRecordTableView.reloadData()
            })
            .store(in: &subscriptions)
        
        searchBar.searchButtonClickedPublisher
            .sink(receiveValue: {
                //print(self.searchBar.text ?? "")
                if let update = try! Realm().objects(SearchRecord.self)
                    .filter(NSPredicate(format: "title = %@", self.searchBar.text ?? ""))
                    .first{ try! Realm().write{
                        update.date = Date()
                    }
                }else{
                    try! Realm().write({
                        try! Realm().add(SearchRecord(title: self.searchBar.text))
                    })
                }
                
                self.dismiss(animated: false)
                self.searchWordDelegate?.sendQuery(query: self.searchBar.text!)
            })
            .store(in: &subscriptions)
    }
    
    private func fetchRecords() {
        records = Array(try! Realm().objects(SearchRecord.self).sorted(byKeyPath: "date", ascending: false))
    }
    
    @objc private func popView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
}

//extension SearchViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
//    {
//        if let update = try! Realm().objects(SearchRecord.self)
//            .filter(NSPredicate(format: "title = %@", self.searchBar.text ?? ""))
//            .first{ try! Realm().write{
//                update.date = Date()
//            }
//        }else{
//            try! Realm().write({
//                try! Realm().add(SearchRecord(title: self.searchBar.text))
//            })
//        }
//        
//        self.dismiss(animated: false)
//        searchWordDelegate?.sendQuery(query: self.searchBar.text!)
//    }
//}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        return records.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecordCell.reuseIdentifier) as? SearchRecordCell,
              let title = records[indexPath.row].title
        else{
            return UITableViewCell()
        }
        cell.setTitleLabelText(title: title)
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            try! Realm().write {
                try! Realm().delete(records[indexPath.row])
            }
            records.remove(at: indexPath.row)
            searchRecordTableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        let searchText = records[indexPath.row].title ?? "empty"
        let record = records[indexPath.row]
        try! Realm().write{
            record.date = Date()
        }
        
        self.dismiss(animated: false)
        searchWordDelegate?.sendQuery(query: searchText)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView?
    {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "searchRecordTableHeaderView")
        else { return UIView() }
        headerView.backgroundView = UIView(frame: headerView.bounds)        
        
        if #available(iOS 14.0, *) {
            var content = headerView.defaultContentConfiguration()
            content.text = "최근 검색어"
            headerView.contentConfiguration = content
        } else {
            headerView.textLabel?.text = "최근 검색어"
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
}
