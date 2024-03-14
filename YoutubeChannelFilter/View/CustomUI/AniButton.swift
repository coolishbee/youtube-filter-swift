//
//  AniButton.swift
//  YoutubeChannelFilter
//
//  Created by james on 3/12/24.
//

import UIKit

class AniButton: UIButton {
    private enum Animation {
        typealias Element = (
            duration: TimeInterval,
            delay: TimeInterval,
            options: UIView.AnimationOptions,
            scale: CGAffineTransform,
            alpha: CGFloat
        )
        
        case touchDown
        case touchUp
        
        var element: Element {
            switch self {
            case .touchDown:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .init(scaleX: 1.3, y: 1.3),
                    alpha: 0.8
                )
            case .touchUp:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .identity,
                    alpha: 1
                )
            }
        }
    }
    
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
            self.animateWhenHighlighted()
        }
    }
    
    private func animateWhenHighlighted() {
        let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
        
        UIView.animate(
            withDuration: animationElement.duration,
            delay: animationElement.delay,
            options: animationElement.options,
            animations: {
                self.transform = animationElement.scale
                self.alpha = animationElement.alpha
            }
        )
    }
}
