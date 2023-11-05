//
//  BottomCellData.swift
//  YoutubeChannelFilter
//
//  Created by james on 2023/10/31.
//

import UIKit

struct CellData {
    let image: UIImage
    let title: String
}

struct BottomCellData {
    
    private(set) var cellData: CellData
    private(set) var handler: (() -> Void)
    
    init(cellData: CellData,
         handler: @escaping (() -> Void)) {
        self.cellData = cellData
        self.handler = handler
    }
}

extension BottomCellData {
    static let channelBlock = CellData(image: UIImage(named: "DeleteIcon")!, title: "채널차단")
    static let videoBlock = CellData(image: UIImage(named: "closeIcon")!, title: "영상차단")
    static let saveVideo = CellData(image: UIImage(named: "photoAdd")!, title: "영상저장")
    static let saveChannel = CellData(image: UIImage(named: "blackAdd")!, title: "채널저장")
}
