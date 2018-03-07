//
//  ChannelCell.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 2/11/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var channelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
        //white is max and alpha is opacity
        self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    
    //boldens unread channels
    func configureCell(channel: Channel){
        //if can't find a value then return empty string
        let title = channel.channelTitle ?? ""
        
        channelName.text = "#\(title)"
        
        channelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }
    
    
    

}
