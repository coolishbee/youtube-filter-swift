//
//  APIConfiguration.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/22.
//

import Foundation

struct APIConfiguration {
    static var _shared: APIConfiguration?
    static var shared: APIConfiguration {
        return guardSharedProperty(_shared)
    }
    
    let youtubeAPIKey: String
    
    init(apiKey: String) {
        self.youtubeAPIKey = apiKey
    }
    
}
