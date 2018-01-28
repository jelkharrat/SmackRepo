//
//  AvatarCell.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/25/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

//make sure enum comes before the CLASS so that it can be accessible to all other files
enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    //first thing that is called when woken up
    //must call super awake from nib to give parent class opportunity to give additional initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func configureCell(index: Int, type: AvatarType){
        if type == AvatarType.dark {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else{
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
        
    }
    
    func setUpView(){
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        //makes sure that  the image view doesnt spill out of the collection view cell
        self.clipsToBounds = true
    }
}
