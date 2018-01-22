//
//  AuthService.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/22/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation

//This is a singleton - can only have one instance of itself and accessible globally
class AuthService {
    static let instance = AuthService()
    
    //this will allow user defaults to persist/won't log out and reset whenever the user closes the app
    //good for strings and labels, not images or passwords
    let defaults = UserDefaults.standard
    
    //this is going to do a check on how we want UI to display
    //if logged in, display user name. If not, say log in
    var isLoggedIn : Bool{
        
        //looks into user defaults and sees if this value exists
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        
        get {
           return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String{
        
        get {
           return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
        
    }
    
}
