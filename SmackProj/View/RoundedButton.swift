//
//  RoundedButton.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/24/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit
@IBDesignable

//when in mains storyboard, can adjust the CGFloat value instead of changing it in the code

class RoundedButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        //part of ibDesignable that is called 
        super.prepareForInterfaceBuilder()
        self.setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = cornerRadius
    }
 

}
