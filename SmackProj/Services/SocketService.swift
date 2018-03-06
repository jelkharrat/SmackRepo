//
//  SocketService.swift
//  SmackProj
//
//  Created by Nessin Elkharrat on 2/12/18.
//  Copyright © 2018 practice. All rights reserved.
//

import UIKit
//persistent connection between app and server
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    override init(){
        super.init()
    }
    
    
    var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    
    //in AppDelegate.swift, need to call this function. In the function applicationDidBecomeActive()
    func establishConnection(){
        socket.connect()
    }
    
    //in AppDelegate.swift, need to call this function. In the function applicationWillTerminate()
    func closeConnection(){
        socket.disconnect()
    }
    
    //part of the socket.io is the emit function which sends info from one place to the other. The server would receive info for a new channel and then would disperse that info to as many devices connected to the server. We would need a function for the device to recieve new info which is the .on function
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    //Need to call this function in the place where we want it to listen for changes, which is in the the ChannelVC
    func getChannel(completion: @escaping CompletionHandler){
        //ack is standard for acknowledgement
        //just calling/declaring the array dataArray here and is being parsed out
        socket.on("channelCreated") { (dataArray, ack) in
            
            //comes back as a type any, so need to cast as string
            guard let channelName = dataArray[0] as? String else {return}
            
            guard let channelDescription = dataArray[1] as? String else {return}
            
            guard let channelID = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelID)
            
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    
    func addMessage (messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        
        completion(true)
    }
    
    
    
    
    
    
    
    
}
