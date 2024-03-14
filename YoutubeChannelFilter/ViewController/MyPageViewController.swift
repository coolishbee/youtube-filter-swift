//
//  MyPageViewController.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/11.
//

import Foundation
import UIKit

private let cellID = "testCell"
class MyPageViewController: UIViewController {
    private let myPageTableView = UITableView(frame: .zero, style: .grouped)
    
    private let sections = ["차단", "저장", "필터링", "기록"]
    private let blockMenu = ["차단된 채널목록", "차단된 동영상목록"]
    private let saveMenu = ["저장된 동영상목록", "저장된 채널목록"]
    private let filterMenu = ["키워드 목록"]
    private let recordMenu = ["최근 시청기록"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        //tableView.backgroundColor = .yellow
        view.addSubview(myPageTableView)
        myPageTableView.translatesAutoresizingMaskIntoConstraints = false
        
        myPageTableView.register(MyPageCell.self, forCellReuseIdentifier: cellID)
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            myPageTableView.topAnchor.constraint(equalTo: view.topAnchor),
            myPageTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myPageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            myPageTableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
}

extension MyPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return blockMenu.count;
        case 1:
            return saveMenu.count;
        case 2:
            return filterMenu.count;
        case 3:
            return recordMenu.count;
        default:
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyPageCell
                
        if indexPath.section == 0 {
            cell.menuLabel.text = blockMenu[indexPath.row]
        } else if indexPath.section == 1 {
            cell.menuLabel.text = saveMenu[indexPath.row]
        } else if indexPath.section == 2 {
            cell.menuLabel.text = filterMenu[indexPath.row]
        } else if indexPath.section == 3 {
            cell.menuLabel.text = recordMenu[indexPath.row]
        } else {
            return UITableViewCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        //cell.backgroundColor = .red
        
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 0 else {
            return nil
        }
        let header = HeaderView()
        //header.backgroundColor = .yellow

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 0
        }
        return 180
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("User Selected: ", String(index))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
