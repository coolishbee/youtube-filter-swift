//
//  CustomButton.swift
//  YoutubeChannelFilter
//
//  Created by james on 3/11/24.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setImage(_ image: UIImage?, 
                           for state: UIControl.State) {
        super.setImage(image, for: state)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.8
            }else{
                self.alpha = 1
            }
        }
    }    
    
    func createImage(_ imageName: String,
                            imgSize pointSize: CGFloat = 20,
                            weight: UIImage.SymbolWeight = .regular,
                            _ scale: UIImage.SymbolScale = .medium) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize,
                                                 weight: weight,
                                                 scale: scale)
        let image = UIImage(systemName: imageName,
                            withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        return image ?? UIImage()
    }
}
