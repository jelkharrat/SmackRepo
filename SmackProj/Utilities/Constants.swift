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

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"


//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
