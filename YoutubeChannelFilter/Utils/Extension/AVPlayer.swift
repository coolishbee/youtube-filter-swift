//
//  AVPlayer.swift
//  YoutubeChannelFilter
//
//  Created by james on 3/14/24.
//

import AVFoundation
import UIKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
    var icon: UIImage {
        let imageName = isPlaying ? "pause.fill" : "play.fill"        
        let image = imageName.generateImage()
        return image
    }
}
