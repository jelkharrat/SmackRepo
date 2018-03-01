//
//  CircleImage.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/28/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit
@IBDesignable

class CircleImage: UIImageView {
//dont need IBinspectable because wont be changing anything in storyboard
    override func awakeFromNib() {
        setUpView()
    }

    func setUpView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
}
