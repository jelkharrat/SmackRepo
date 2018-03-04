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
    @IBOutlet weak var channelNameLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows you to tap the button and reveal what is in the rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //allows you to use the drag feature
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        //going to do a check to see if logged in. if yes, then call finduserbyemail function to populate user info again
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserbyEmail(completion: { (success) in
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        
        /*
        //below is improvised cuz video is chreech
        if AuthService.instance.isLoggedIn{
            MessageService.instance.findAllChannel { (success) in
                
            }
        }else{
            UserDataService.instance.logOutUser()
            //maybe dismiss to main screen?
            print("not working jabroni")
            return
        }
      */
        

    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn{
            //get channels
            OnLogInGetMessages()
        }else{
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification){
        updateWithChannel()
    }
    
    func updateWithChannel(){
        //if cant find label, set to nothing
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
    }
    
    func OnLogInGetMessages(){
        MessageService.instance.findAllChannel { (success) in
            if success {
                //do stuff w channel
            }
        }
    }


}
