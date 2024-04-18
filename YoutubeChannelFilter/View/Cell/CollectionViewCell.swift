//
//  CollectionViewCell.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/16/24.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = String(describing: CollectionViewCell.self)

    private var videoRecords: [VideoDataRecord] = []

    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Record"
        label.textColor = Color.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.background
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = Color.background
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(sectionTitleLabel)
        addSubview(collectionView)
        
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(collectionView.snp.top).offset(-5)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        collectionView.register(PreviewVideoCell.self, forCellWithReuseIdentifier: PreviewVideoCell.cellReuseIdentifier)
    }
    
    func configure(records: [VideoDataRecord], _ sectionText: String) {
        self.videoRecords = records
        self.sectionTitleLabel.text = sectionText
        collectionView.reloadData()
    }

}

//MARK: - CollectionView Delegate
extension CollectionViewCell: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {        
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewVideoCell.cellReuseIdentifier,
                                                      for: indexPath) as! PreviewVideoCell
        let recordData = self.videoRecords[indexPath.item]
        cell.configure(record: recordData)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width / 2.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.videoRecords.count
    }
    
}
