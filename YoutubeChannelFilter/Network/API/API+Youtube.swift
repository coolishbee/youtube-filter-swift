//
//  API+Youtube.swift
//  YoutubeChannelFilter
//
//  Created by james on 2023/11/03.
//

import Foundation

extension API {
    
    static func getYoutubeList(
        searchWord word: String,
        completionHandler completion: @escaping ([VideoData]?, Error?) -> Void
    )
    {
        var videos = [VideoData]()
        
        API.youtubeSearch(searchWord: word) { result in
            switch result {
            case .success(let respSearch):
                for item in respSearch.items {
                    let videoData : VideoData = VideoData()
                    videoData.identifier = item.id.videoId
                    videoData.title = String(htmlEncodedString: item.snippet.title)!
                    videoData.channel = item.snippet.channelTitle
                    videoData.date = item.snippet.publishedAt.uploadDate()
                    videoData.videoImg = item.snippet.thumbnails.high.url
                    
                    let strKind = item.id.kind
                    if let idx = strKind.firstIndex(of: "#") {
                        let addIdx = strKind.index(idx, offsetBy: 1)
                        videoData.kind = VideoKind(rawValue: String(strKind[addIdx...]))!
                    }
                    
                    switch videoData.kind {
                    case .Video:
                        videoData.identifier = item.id.videoId
                    case .Channel:
                        videoData.identifier = item.id.channelId
                    case .PlayList:
                        videoData.identifier = item.id.playlistId
                    }
                    videos.append(videoData)
                }
                completion(videos, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
        
}
