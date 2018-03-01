//
//  ChannelVC.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    //Takes us from CreateAccountVC to Channel
    //In main.storyboard, control drag from yellow box (UIViewController) to Orange Box all the way on the right and choose the function. Also need to give it an identifier in main.storyboard
    //Then need to make an IBACTION for the close image in the CreateAccountVC file
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        
        //The notification is being broadcasted in the createAccountVC and is being listened for here
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil )
        
        
        //all this is doing is listening for any changes (seeing if any channels are added)
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        
    }
    
    //when opening the app with a user log in, the view  may not have been instantiated
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            //Show Profile Image
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: TO_LOGIN, sender: nil)

        }
    }
    
    //selector for notification
    @objc func userDidChange(_ notif: Notification) {
   setUpUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
    tableView.reloadData()
    }
    
    func setUpUserInfo(){
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            loginBtn.setTitle("Log In", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            //reloads the table that was removed when logged out
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }else{
            return UITableViewCell ()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // when select a row, save into message service variable, then notify chatVC, then dismiss
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        //slides menu back
        self.revealViewController().revealToggle(animated: true)
    }
    
    
    
    
}
