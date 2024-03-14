//
//  SearchRecordTableViewCell.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/29.
//

import UIKit
import SnapKit

class SearchRecordCell: UITableViewCell {
    static let reuseIdentifier = "searchRecordTableViewCell"
    
    public var indexPath: IndexPath?
    private(set) var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setTitleLabelText(title: String) {
        titleLabel.text = title
    }
    
    private func setTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.leading.equalTo(contentView).inset(20)
            label.top.bottom.equalTo(contentView)
        }
    }
    
}
