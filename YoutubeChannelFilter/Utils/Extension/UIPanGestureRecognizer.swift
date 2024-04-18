//
//  UIPanGestureRecognizer.swift
//  YoutubeChannelFilter
//
//  Created by james on 1/24/24.
//

import UIKit

extension UIPanGestureRecognizer {
    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        static let up = PanGestureDirection(rawValue: 1 << 0)
        static let down = PanGestureDirection(rawValue: 1 << 1)
        static let left = PanGestureDirection(rawValue: 1 << 2)
        static let right = PanGestureDirection(rawValue: 1 << 3)
    }
    
    func direction(in view: UIView) -> PanGestureDirection {
        let vel = self.velocity(in: view)
        let isVerticalGesture = abs(vel.y) > abs(vel.x)
        if isVerticalGesture {
            return vel.y > 0 ? .down : .up
        }else {
            return vel.x > 0 ? .right : .left
        }
    }
}
