//
//  BottomCell.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/24.
//

import UIKit
import SnapKit

class BottomCell: UITableViewCell {
        
    enum Design {
        static var spacing: CGFloat { return 34.0 }
        static var font: UIFont { return .r14 }
        static var margin: CGFloat { return 16.0 }
    }
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        //let backgroundView = UIView()
        //backgroundView.backgroundColor = Color.veryLightGrey
        //self.selectedBackgroundView = backgroundView
        self.addSubview(baseView)
        baseView.addSubview(iconImage)
        baseView.addSubview(titleLabel)
        
        baseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(Design.margin)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-Design.margin)
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
//                make.leading.equalTo(self.safeAreaLayoutGuide).offset(Design.margin)
//                make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-Design.margin)
//            } else {
//                make.top.equalTo(self.snp.top)
//                make.leading.equalTo(self).offset(Design.margin)
//                make.trailing.equalTo(self).offset(-Design.margin)
//            }
            make.bottom.equalTo(self)
        }
        
        iconImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(Design.spacing)
            make.centerY.equalTo(baseView)
            make.leading.equalTo(baseView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(baseView)
            make.leading.equalTo(iconImage.snp.trailing).offset(10)
            make.trailing.equalTo(baseView)
        }
        
        self.backgroundColor = Color.background
        iconImage.tintColor = Color.black
        titleLabel.font = Design.font
        titleLabel.textColor = Color.black
    }
    
    func configure(data: CellData) {
        self.iconImage.image = data.image.withRenderingMode(.alwaysTemplate)
        self.titleLabel.text = data.title
        self.titleLabel.font = Design.font
        self.titleLabel.textColor = Color.black
    }
}
