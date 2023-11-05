//
//  PlayListTableCell.swift
//  YoutubeChannelFilter
//
//  Created by james on 2023/10/20.
//

import UIKit

class PlayListTableCell: UITableViewCell {
    @IBOutlet weak var videoImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var channel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var playListFlag: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
