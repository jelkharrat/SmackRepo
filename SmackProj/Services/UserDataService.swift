//
//  UserDataService.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 1/24/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation

class  UserDataService {
    
    static let instance = UserDataService()
    
    //other classes can  use it and see it but cannot be changed by any other class but this one
    public private(set) var id = ""
     public private(set) var avatarColor = ""
     public private(set) var avatarName = ""
     public private(set) var email = ""
     public private(set) var name = ""
    
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String){
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    //This functions take array of strings and breaks into different components to save RGB values into user data
    func returnUIColor(components: String) -> UIColor {
        
        //interprets and converts NSstring object into number and string values
        let scanner = Scanner(string: components)
        
        let skipped = CharacterSet(charactersIn: "[], ")
        
        let comma = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        //backup plan if upwrapping doesn't work
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}

        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)

        let newUIColor =  UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
    
    func logOutUser(){
        id = ""
        name = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
    }
    
    
    
    
    
    
    
}
