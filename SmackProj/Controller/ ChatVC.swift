//
//  ChatVC.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    //usually an action but in this case we assign it as an outlet and assign an action to it in the viewdidload
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //within the server there are client.on/io.emit functions listening and sending out signals for events that listen for typing users
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //function in view that shifts textfield up
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        //automatic sizing
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendBtn.isHidden = true
        
        //tap anywhere to put keyboard away
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        //allows you to tap the button and reveal what is in the rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //allows you to use the drag feature
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//
//                //if there are multiple messages, scroll to the bottom one
//                if MessageService.instance.messages.count > 0 {
//                    //last message
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
//                }
//            }
//        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    
                 self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true) 
                }
            }
        }
        
        
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            
            var names = ""
            
            var numberOfTypers = 0
            
            //looping through dictionary and gaining access to key(typingUser) and value(channel)
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn ==  true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
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
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn{
            //get channels
            OnLogInGetMessages()
            tableView.reloadData()
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
        getMessages()
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        if messageTxtBox.text == "" {
        isTyping = false
        sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
    } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId:  UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTxtBox.text  = ""
                    //dissmisses the keyboard
                    self.messageTxtBox.resignFirstResponder()
                    
                      SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                    self.messageTxtBox.attributedPlaceholder = NSAttributedString(string: "Message sent...Fuck off!")
                    
                }
            })
        }
    }
    
    
    
    func OnLogInGetMessages(){
        MessageService.instance.findAllChannel { (success) in
            if success {
                //do stuff w channel
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.channelNameLbl.text = "No Channels Yet, Bitch!"
                }
                
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            
            if success {
                self.tableView.reloadData()
            }
             
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }


}
