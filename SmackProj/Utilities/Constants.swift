//
//  Constants.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/21/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation

//Completion Handler that thats notifies when a web request has been made
//typealias is just something that allows you to specify what kind of variable it is (Bool in this case)
//(_ Success: Bool) -> () this is a closure, which is a function that can be passed around in code
//doing a web request and use the closure/completion handler to check later on to see if the bool tells us that the web request has been made
typealias CompletionHandler = (_ Success: Bool) -> ()

//URL
let BASE_URL = "https://chatitupbruh.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_CHANNELS = "\(BASE_URL)channel"
//Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)

//Notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNELS_SELECTED = Notification.Name("channelSelected")




//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"


//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
