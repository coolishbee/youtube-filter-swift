//
//  PreviewVideoCell.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/16/24.
//

import UIKit
import SnapKit

class PreviewVideoCell: UICollectionViewCell {
    
    static let cellReuseIdentifier = String(describing: PreviewVideoCell.self)

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let channelNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }        
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 3
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClicked))
        addGestureRecognizer(tap)
        //tap.cancelsTouchesInView = false        
        
        addSubview(thumbnailImageView)
        insertSubview(channelNameLabel, aboveSubview: thumbnailImageView)
        insertSubview(videoTitleLabel, aboveSubview: thumbnailImageView)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        channelNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        videoTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelNameLabel.snp.leading)
            make.bottom.equalTo(channelNameLabel.snp.top)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(record: VideoDataRecord) {
        thumbnailImageView.sd_setImage(with: URL(string: record.thumbnailURL),
                                       placeholderImage: #imageLiteral(resourceName: "placeholder"))
        videoTitleLabel.text = record.title
        channelNameLabel.text = record.channel
    }
    
    @objc func didClicked() {
        print("didClicked")
    }
}
