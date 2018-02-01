//
//  ChatVC.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //Outlets
    //usually an action but in this case we assign it as an outlet and assign an action to it in the viewdidload
    @IBOutlet weak var menuBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows you to tap the button and reveal what is in the rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //allows you to use the drag feature
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //going to do a check to see if logged in. if yes, then call finduserbyemail function to populate user info again
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserbyEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        
        MessageService.instance.findAllChannel { (success) in
            
        }

    }


}
