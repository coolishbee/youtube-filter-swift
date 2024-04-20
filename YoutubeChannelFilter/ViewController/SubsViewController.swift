//
//  SubsViewController.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/16/24.
//

import UIKit
import RealmSwift

class SubsViewController: UICollectionViewController {
        
    private let category = ["최근 시청기록", "차단된 채널목록", "저장된 채널목록", "차단된 동영상목록", "저장된 동영상목록"]
    
    var notificationToken: NotificationToken?
    var results : Results<VideoDataRecord>?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        results = RealmManager.shared.load(VideoDataRecord.self,
                                           sortKey: "date",
                                           ascending: false)
        
        notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.collectionView else { return }
            switch changes {
            case .initial(let users):
                tableView.reloadData()
            case .update(let users, let deletions, let insertions, let modifications):
                tableView.reloadData()
                
                // FIXME: from reloadData to performBatchUpdates
//                tableView.performBatchUpdates({
//                    tableView.deleteItems(at: deletions.map({ IndexPath(item: $0, section: 0)} ))
//                    tableView.insertItems(at: insertions.map({ IndexPath(item: $0, section: 0)} ))
//                    tableView.reloadItems(at: modifications.map({ IndexPath(item: $0, section: 0)} ))
//                }, completion: { finished in
//                    print(finished.description)
//                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    private func setupView() {
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.cellReuseIdentifier)
        collectionView.backgroundColor = Color.background
    }
}

extension SubsViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return setupCells(indexPath.item, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    private func setupCells(_ type: Int, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellReuseIdentifier,
                                                      for: indexPath) as! CollectionViewCell
        let filteredRecords = results?.where {
            $0.saveType == type
        }
        
        if let array = filteredRecords?.toArray() {
            cell.configure(records: array, category[type])
            return cell
        }else{
            return cell
        }
    }
}
