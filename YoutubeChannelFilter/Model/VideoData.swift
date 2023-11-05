//
//  VideoData.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/21.
//

import Foundation

enum VideoKind: String {
    case Video = "video"
    case Channel = "channel"
    case PlayList = "playlist"
}

class VideoData {    
    public var identifier: String?
    public var title: String
    public var videoImg: String
    public var channel: String
    public var date: String
    
    public var kind: VideoKind
    
    init(identifier: String,
         title: String,
         videoImg: String,
         channel: String,
         date: String,
         kind: VideoKind)
    {
        self.identifier = identifier
        self.title = title
        self.videoImg = videoImg
        self.channel = channel
        self.date = date
        self.kind = kind
    }
    
    init() {
        self.identifier = ""
        self.title = ""
        self.videoImg = ""
        self.channel = ""
        self.date = ""
        self.kind = VideoKind.Video
    }
    
}
