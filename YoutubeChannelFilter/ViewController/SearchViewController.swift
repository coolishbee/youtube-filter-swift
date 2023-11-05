//
//  SearchViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/28.
//

import UIKit
import SnapKit
import RealmSwift
import RxSwift
import RxCocoa

protocol SearchWordDelegate: AnyObject {
    func sendQuery(query: String)
}

final class SearchViewController: UIViewController {
    private var records = [SearchRecord]()
    //private let backBtnImageView = UIImageView()
    //private let searchBar = UISearchBar()
    //private let searchRecordTableView = UITableView()
    weak var searchWordDelegate: SearchWordDelegate?
    
    private var disposeBag = DisposeBag()
    
    
    lazy var backBtnImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.backward")
        view.tintColor = .darkGray
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "YouTube 검색"
        bar.delegate = self
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
        
        //setBackBtnImageView()
        //setSearchBar()
        //setSearchRecordTableView()
        //addTapGesture()
        
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(popView(_:)))
        backBtnImageView.addGestureRecognizer(gesture)
        view.addSubview(backBtnImageView)
        backBtnImageView.snp.makeConstraints { imageView in
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.width.height.equalTo(30)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { searchBar in
            searchBar.leading.equalTo(backBtnImageView.snp.trailing)
            searchBar.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        backBtnImageView.snp.makeConstraints { imageView in
            imageView.centerY.equalTo(searchBar.snp.centerY)
        }
        
        view.addSubview(searchRecordTableView)
        searchRecordTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(searchBar.snp.bottom)
            tableView.leading.trailing.bottom.equalTo(view)
        }
    }
    
    private func bindRx() {
        searchBar.rx.text
            .orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (str) in
                guard let self = self else {
                    return
                }
                if(str.isEmpty) {
                    print("str is empty")
                    self.fetchRecords()
                }else{
                    print(str)
                    let word = str.trimmingCharacters(in: .whitespaces)
                    
                    self.records = Array(try! Realm()
                        .objects(SearchRecord.self)
                        .filter(NSPredicate(format: "title CONTAINS %@", word))
                        //.filter("title CONTAINS[cd] %@", str)
                        .sorted(byKeyPath: "date", ascending: false))
                }
                
                self.searchRecordTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func fetchRecords() {
        records = Array(try! Realm().objects(SearchRecord.self).sorted(byKeyPath: "date", ascending: false))
    }
    
    @objc private func popView(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
    
//    private func setBackBtnImageView() {
//        backBtnImageView.image = UIImage(systemName: "arrow.backward")
//        backBtnImageView.tintColor = .darkGray
//        backBtnImageView.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(popView(_:)))
//        backBtnImageView.addGestureRecognizer(gesture)
//        view.addSubview(backBtnImageView)
//        backBtnImageView.snp.makeConstraints { imageView in
//            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
//            imageView.width.height.equalTo(30)
//        }
//    }
    
//    private func setSearchBar() {
//        searchBar.placeholder = "YouTube 검색"
//        searchBar.delegate = self
//        //searchBar.barTintColor = Color.veryLightGrey
//        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        searchBar.becomeFirstResponder()
//        view.addSubview(searchBar)
//        searchBar.snp.makeConstraints { searchBar in
//            searchBar.leading.equalTo(backBtnImageView.snp.trailing)
//            searchBar.top.trailing.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        backBtnImageView.snp.makeConstraints { imageView in
//            imageView.centerY.equalTo(searchBar.snp.centerY)
//        }
//    }
    
//    private func setSearchRecordTableView() {
//        searchRecordTableView.register(SearchRecordCell.self,
//                                       forCellReuseIdentifier: SearchRecordCell.reuseIdentifier)
//        searchRecordTableView.register(UITableViewHeaderFooterView.self,
//                                       forHeaderFooterViewReuseIdentifier: "searchRecordTableHeaderView")
//        searchRecordTableView.dataSource = self
//        searchRecordTableView.delegate = self
//        searchRecordTableView.keyboardDismissMode = .onDrag
//        searchRecordTableView.backgroundColor = .systemBackground
//
//        view.addSubview(searchRecordTableView)
//        searchRecordTableView.snp.makeConstraints { tableView in
//            tableView.top.equalTo(searchBar.snp.bottom)
//            tableView.leading.trailing.bottom.equalTo(view)
//        }
//    }
    
    //    private func addTapGesture() {
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
    //        view.addGestureRecognizer(tapGesture)
    //    }
    //
    //    @objc
    //    private func hideKeyboard(_ sender: Any) {
    //        view.endEditing(true)
    //    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //        let result = try! Realm().objects(SearchRecord.self)
        //            .filter {
        //                return $0.title == self.searchBar.text
        //            }
        
        //        let record = records.filter {
        //            return $0.title == self.searchBar.text
        //        }
        //        print("search record!! ", record.first?.title ?? "empty")
        
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
        searchWordDelegate?.sendQuery(query: self.searchBar.text!)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        //return try! Realm().objects(SearchRecord.self).count
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
//        guard let cell = searchRecordTableView.cellForRow(at: indexPath) as? SearchRecordTableViewCell,
//              let searchText = cell.titleLabel.text else { return }
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
        //headerView.backgroundView?.backgroundColor = .systemBackground
        
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
