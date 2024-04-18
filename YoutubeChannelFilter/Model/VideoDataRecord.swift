//
//  VideoDataRecord.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/16/24.
//

import Foundation
import RealmSwift

class VideoDataRecord: Object {
    @Persisted var title: String
    @Persisted var channel: String
    @Persisted var thumbnailURL: String
    @Persisted var identifier: String
    @Persisted var saveType: Int
    
    @Persisted var date: Date = Date()

    override init() {

    }

    init(title: String, 
         channel: String,
         url: String, 
         id: String,
         type: Int) {
        self.title = title
        self.channel = channel
        self.thumbnailURL = url
        self.identifier = id
        self.saveType = type
        self.date = Date()
    }
}

enum VideoSaveType: Int {
    case RecentRecord = 0
    case ChannelBlock
    case SaveChannel
    case VideoBlock
    case SaveVideo
    
    var description: String {
        return String(describing: self)
    }
}
