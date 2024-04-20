//
//  Results+Array.swift
//  YoutubeChannelFilter
//
//  Created by james on 4/20/24.
//

import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
    
}
