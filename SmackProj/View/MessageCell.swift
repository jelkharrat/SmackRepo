//
//  MessageCell.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 3/5/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
    @IBOutlet weak var messageBodyLbl: UILabel!
    @IBOutlet weak var userImg: CircleImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        messageBodyLbl.text = message.message
        userNameLbl.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)

        let isoFormatter = ISO8601DateFormatter()
        //need to have letter Z
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))

        let newFormatter = DateFormatter()

        newFormatter.dateFormat = "MMM d, h:mm a"

        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)

            timeStampLbl.text = finalDate
        }
    }
    
}
