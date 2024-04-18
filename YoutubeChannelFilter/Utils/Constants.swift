//
//  Constants.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/04.
//

import UIKit

struct Constants {
    struct DevServer {
        static let baseURL = "https://www.googleapis.com"
    }
    struct LiveServer {
        static let baseURL = ""
    }
    
    static let jsUrlEvaluator = "document.getElementsByTagName('video')[0].src"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}

enum VideoPlayerMode: Int {
    case expand, minimize
}

let MINI_PLAYER_HEIGHT: CGFloat = 60
let MINI_PLAYER_WIDTH: CGFloat = UIScreen.main.bounds.width / 3 + 10
