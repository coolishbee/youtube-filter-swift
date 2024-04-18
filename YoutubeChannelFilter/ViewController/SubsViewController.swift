//
//  SubsViewController.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/16/24.
//

import UIKit
import RealmSwift

class SubsViewController: UICollectionViewController {
    
    private var videoRecords = [VideoDataRecord]()
    private let sections = ["최근 시청기록", "차단된 채널목록", "저장된 채널목록", "차단된 동영상목록", "저장된 동영상목록"]
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        videoRecords = Array(RealmManager.shared.load(VideoDataRecord.self,
                                                      sortKey: "date",
                                                      ascending: false))
        self.collectionView.reloadData()
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
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, 
                                 didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    private func setupCells(_ section: Int, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellReuseIdentifier,
                                                      for: indexPath) as! CollectionViewCell
        
        switch section {
        case VideoSaveType.RecentRecord.rawValue:
            let filteredRecords = Array(RealmManager.shared.load(VideoDataRecord.self)
                .filter(NSPredicate(format: "saveType == %d", VideoSaveType.RecentRecord.rawValue))
                .sorted(byKeyPath: "date", ascending: false))
                        
            cell.configure(records: filteredRecords, sections[VideoSaveType.RecentRecord.rawValue])
            return cell
        case VideoSaveType.ChannelBlock.rawValue:
            let filteredRecords = Array(RealmManager.shared.load(VideoDataRecord.self)
                .filter(NSPredicate(format: "saveType == %d", VideoSaveType.ChannelBlock.rawValue))
                .sorted(byKeyPath: "date", ascending: false))
            
            cell.configure(records: filteredRecords, sections[VideoSaveType.ChannelBlock.rawValue])
            return cell
        case VideoSaveType.SaveChannel.rawValue:
            let filteredRecords = Array(RealmManager.shared.load(VideoDataRecord.self)
                .filter(NSPredicate(format: "saveType == %d", VideoSaveType.SaveChannel.rawValue))
                .sorted(byKeyPath: "date", ascending: false))
            
            cell.configure(records: filteredRecords, sections[VideoSaveType.SaveChannel.rawValue])
            return cell
        case VideoSaveType.VideoBlock.rawValue:
            let filteredRecords = Array(RealmManager.shared.load(VideoDataRecord.self)
                .filter(NSPredicate(format: "saveType == %d", VideoSaveType.VideoBlock.rawValue))
                .sorted(byKeyPath: "date", ascending: false))
            
            cell.configure(records: filteredRecords, sections[VideoSaveType.VideoBlock.rawValue])
            return cell
        case VideoSaveType.SaveVideo.rawValue:
            let filteredRecords = Array(RealmManager.shared.load(VideoDataRecord.self)
                .filter(NSPredicate(format: "saveType == %d", VideoSaveType.SaveVideo.rawValue))
                .sorted(byKeyPath: "date", ascending: false))
            
            cell.configure(records: filteredRecords, sections[VideoSaveType.SaveVideo.rawValue])
            return cell
        default:
            print("default")
            return cell
        }
    }
}
