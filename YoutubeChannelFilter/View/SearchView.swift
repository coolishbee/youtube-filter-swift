//
//  SearchView.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/03.
//

import UIKit

class SearchView: UIButton {
    
    lazy var searchImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "xmark")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Color.black
        return view
    }()
    
    lazy var textField: UITextField = {
        let text = UITextField()
        text.isUserInteractionEnabled = false
        text.translatesAutoresizingMaskIntoConstraints = false
        //text.font = .r16
        text.attributedPlaceholder = NSAttributedString(
            string: "YouTube 검색",
            attributes:
                [NSAttributedString.Key.foregroundColor: Color.black,
                 NSAttributedString.Key.font: UIFont.r16])
        return text
    }()
    
    func configure(word: String?) {
        self.textField.text = word
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        self.backgroundColor = Color.system
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error!!!")
    }
    
    func initView() {
        self.addSubview(searchImageView)
        self.addSubview(textField)
        
        searchImageView.snp.makeConstraints { imgView in
            imgView.leading.equalToSuperview().offset(8)
            imgView.centerY.equalToSuperview()
            imgView.width.height.equalTo(20)
        }
        textField.snp.makeConstraints { txtField in
            txtField.top.bottom.equalToSuperview()
            txtField.trailing.equalToSuperview()
            txtField.leading.equalTo(searchImageView.snp.trailing).offset(8)
        }
    }
}
