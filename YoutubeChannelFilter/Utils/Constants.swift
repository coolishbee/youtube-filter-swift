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
    
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}
