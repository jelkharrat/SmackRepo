//
//  CreateAccountVC.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    //outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor : UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    
    //function that is called after selecting avatar in AvatarPickerVC to update profile
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            //global variable
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            //local variable
            avatarName = UserDataService.instance.avatarName
            
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255

        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        UIView.animate(withDuration: 0.32){
            self.userImg.backgroundColor = self.bgColor
        }
        
    }
    
    //sending over email and password
    @IBAction func CreateAccountPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        //guard let sets a constant under a condition which takes form in the shape of a comma
        //guard let is another way of unwrapping optional strings which is why we need to unwrap them
        guard let email = emailTxt.text , emailTxt.text != "" else {
            return
        }
        
        guard let pass = passTxt.text , passTxt.text != "" else {
            return
        }
        
        guard let name = usernameTxt.text , usernameTxt.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, pass: pass, completion: { (success) in
                    if success{
                       // print("Logged in!", AuthService.instance.authToken)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success{
                                //print(UserDataService.instance.avatarName, UserDataService.instance.name)
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                                //sends out a notification that a post has been made
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
                //print("Rregistered User")
            }
        }
        
    }
    
   
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    //need to programmatically change the color of placeholders
    func setUpView(){
        //this allows user to tap screen and keyboard will go away. Need to create function for action/selector (handleTap())
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
        
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
         emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
         passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
    }
    
    //this is an objective-c function
    @objc func handleTap(){
        //dismisses keyboard w tap
        view.endEditing(true)
    }
    

}
