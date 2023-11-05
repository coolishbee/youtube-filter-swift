//
//  HeaderView.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/09/16.
//

import UIKit

class HeaderView: UIView {

    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "user")
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 120 / 2
        //iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
