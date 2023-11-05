//
//  RespSearch.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/08/04.
//

import Foundation

struct RespSearch: Codable {
    let items: [RespSearch.VideoItem]

    struct VideoItem: Codable {
        let id: Id
        let snippet: RespSearch.Snippet
    }

    struct Id: Codable {
        let kind: String
        let videoId: String?
        let channelId: String?
        let playlistId: String?
    }

    struct Snippet: Codable {
        let title: String
        let publishedAt: String
        let description: String
        let channelTitle: String
        let thumbnails: RespSearch.Thumbnails
    }

    struct Thumbnails: Codable {
        let `default`: RespSearch.Thumbnail
        let medium: RespSearch.Thumbnail
        let high: RespSearch.Thumbnail
    }

    struct Thumbnail: Codable {
        let url: String
        let width: Int?
        let height: Int?
    }
}
