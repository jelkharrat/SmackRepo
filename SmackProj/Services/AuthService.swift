//
//  AuthService.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/22/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation
//library built on top of Apples URL session framework that makes making web requests easier
import Alamofire
import SwiftyJSON

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
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCasedEmail,
            "password": password
        ]
        
        //posting to the URL the body of the email which contains the email and password to register the user and store data within the data
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, pass: String, completion: @escaping CompletionHandler) {
     
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCasedEmail,
            "password": pass
        ]
        
        //in this request, sending out email and pass data, THEN receiving data in the form of access keys in JSON which will need to be parsed or SWIFTYJSON
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                
//                //JSON parsing
//                if let json = response.result.value as? Dictionary<String,Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                //swiftyJson
                guard let data = response.data else {
                    return
                }
                let json = JSON(data: data)
                
                //StringValue will either auto unwrap for you or an empty string
                self.userEmail = json["user"].stringValue
                
                self.authToken = json["token"].stringValue
                
                
                self.isLoggedIn = true
                completion(true)
            } else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCasedEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data =  response.data else{return}
                //see function below
               self.setUserData(data: data)
                completion(true)
                
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    //After logging in, the user gets an authtoken, username... This function uses those assets to look up rest of user info
    func findUserbyEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data =  response.data else{return}
                //see function below
                self.setUserData(data: data)
                completion(true)
                
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func setUserData(data: Data) {
        let json = JSON(data: data)
        let id = json["_id"].stringValue
        let email = json["email"].stringValue
        let avatarName = json["avatarName"].stringValue
        let avatarColor = json["avatarColor"].stringValue
        let name = json["name"].stringValue
        
        UserDataService.instance.setUserData(id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
    }
    
    
    
}
