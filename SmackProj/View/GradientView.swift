//
//  GradientView.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit
//allows you to view changes in real time in storyboard
@IBDesignable

class GradientView: UIView {

    //designates certain variables to be able to change in real time
    @IBInspectable var topColor : UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) {
       
        //if we change the layout in storyboard, this allows the layout in storyboard to be updated in real time
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor : UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1) {
        
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
         let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        //gradient colors start from top left (0,0) and goes down to bottom right (1,1)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //setting the length/width of colors to the uiview of what it is a subclass of
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }

}
