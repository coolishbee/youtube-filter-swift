//
//  SearchRecord.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/29.
//

import Foundation
import RealmSwift

class SearchRecord: Object {
    @Persisted var title: String? = ""
    @Persisted var date: Date = Date()

    override init() {

    }

    init(title: String?) {
        self.title = title
        self.date = Date()
    }
}
