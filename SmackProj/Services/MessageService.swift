//
//  MessageService.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 2/1/18.
//  Copyright © 2018 practice. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    
    //variable for the channel we are currently looking at. Needs to be optional incase we log out
    var selectedChannel : Channel?
    
    //web request that pulls in all the channels
    func findAllChannel(completion: @escaping CompletionHandler){
        Alamofire.request(URL_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                guard let data = response.data else{return}
                if let json = JSON(data: data).array{
                for item in json{
                    let name = item["name"].stringValue
                    let channelDescription = item["description"].stringValue
                    let id = item["item"].stringValue
                    let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                    self.channels.append(channel)
                }
                   // print(self.channels[0].channelTitle)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    
                    completion(true)
            }
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                
                guard let data = response.data else {return}
                if let json = JSON(data: data).array{
                    for item in json{
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)

                        self.messages.append(message)
                
                    }
                    
                    print(self.messages)
                    completion(true)
                }
                
                
            } else {
                //debugPrint(response.result.response as Any)
                completion(false)
            }
        }
    }
    
    //removes all the channels from the array (for once we are logged out)
    func clearChannels(){
        channels.removeAll()
    }
    
    func clearMessages(){
        messages.removeAll()
    }
    
    
}
