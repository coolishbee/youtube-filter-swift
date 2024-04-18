//
//  CoolishUtils.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/22.
//

import Foundation
import UIKit

class CoolishUtils {
    
//    static func alertA (vc: UIViewController, msg: String)
//    {
//        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: UIAlertController.Style.alert)
//        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
//        alert.addAction(action)
//        vc.present(alert, animated: true)
//    }
    
    static func systemModeColor() -> UIColor {
        let dynamicColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.red
            }else {
                return UIColor.green
            }
        })
        return dynamicColor
    }
}

func guardSharedProperty<T>(_ input: T?) -> T {
    guard let shared = input else {
        print("error!!")
        Log.fatalError("Use \(T.self) before setup. ")
    }
    return shared
}

enum Log {
    static func fatalError(
        _ message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never
    {
        Swift.fatalError("[YoutubeChannelFilter] \(message())", file: file, line: line)
    }
}
