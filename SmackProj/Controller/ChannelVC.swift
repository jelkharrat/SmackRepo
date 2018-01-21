//
//  ChannelVC.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    
    //Takes us from CreateAccountVC to Channel
    //In main.storyboard, control drag from yellow box (UIViewController) to Orange Box all the way on the right and choose the function. Also need to give it an identifier in main.storyboard
    //Then need to make an IBACTION for the close image in the CreateAccountVC file
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
}
