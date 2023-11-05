//
//  VideoTableCell.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/15.
//

import UIKit

class VideoTableCell: UITableViewCell {

    @IBOutlet weak var videoImg: UIImageView!    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var channel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var playListFlag: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

