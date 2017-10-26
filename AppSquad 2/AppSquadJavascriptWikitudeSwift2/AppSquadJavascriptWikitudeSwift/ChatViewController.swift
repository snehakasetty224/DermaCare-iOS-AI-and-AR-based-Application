//
//  ChatViewController.swift
//  AppSquadJavascriptWikitudeSwift
//
//  Created by Sneha Kasetty Sudarshan on 5/10/17.
//  Copyright © 2017 Sneha Kasetty Sudarshan. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var chatTableView: UITableView!
    
    @IBOutlet var textInput: UITextField!
    @IBOutlet var bottomBarConstraint: NSLayoutConstraint!
    
    var severe : String!
 

    let dm = DataManager.sharedInstance
    var chatContext:JSON = nil
    
    var chatData = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Intializing the Keyboard event
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 200
        refreshAndScrollTable(animated:false)
        
        //send empty request to establish conversation
        messageSend(message: nil, context: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    
    @IBAction func backButtonPress(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    //Message from user to server
    @IBAction func sendMessage(_ sender: AnyObject) {
        let value = textInput.text
        if ((value?.characters.count)! > 0) {
            displayMessage(message: value!, from: "me")
            textInput.text = ""
            messageSend(message: value, context: self.chatContext)
        }
    }
    
    //Message from server to user
    func messageSend(message:String?, context:JSON?) {
        dm.postMessage(message: message, context:context) { (json) in
            if let json = json {
                
                if let responseText = json["output"]["text"].string {
                    self.displayMessage(message: responseText, from: "server")
                }
                
                self.chatContext = json["context"]
            }
        }
    }
    
    func messageReceived(message:[String:Any]) {
        
    }
    //Appending message to chat data
    func displayMessage(message:String, from:String) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let time = String(format: "%d : %d",hour,minute)
        chatData.append(["time":time, "message":message, "from":from]) 
        refreshAndScrollTable(animated:true)
    }
    
    func refreshAndScrollTable(animated:Bool) {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            //self.chatTableView.scrollToLastRow(animated:animated)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendMessage(self)
        return false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        bottomBarConstraint.constant = keyboardSize - 1.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        bottomBarConstraint.constant = -1
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    // Rendering table view cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageData = chatData[indexPath.row]
        var cell:ChatMessageViewCell? = nil
        if ( (messageData["from"] as? String) != "me" ) {
            cell = tableView.dequeueReusableCell(withIdentifier: "serverChatViewCell") as? ChatMessageViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "myChatViewCell") as? ChatMessageViewCell
        }
        
        cell?.setMessage(data:messageData)
        
        return cell!
    }
    
  
}
