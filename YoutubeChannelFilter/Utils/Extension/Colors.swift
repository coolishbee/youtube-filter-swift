//
//  Colors.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/24.
//

import UIKit

struct Color {
    static var dim = UIColor(named: "Dim")!
    static var background = UIColor(named: "Background")!
    static var system = UIColor(named: "System")!
    static var black = UIColor(named: "Black")!
    static var grey = UIColor(named: "Grey")!
    static var veryLightGrey = UIColor(named: "VeryLightGrey")!    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
