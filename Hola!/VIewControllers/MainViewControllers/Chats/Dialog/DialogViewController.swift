//
//  DialogViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 17.05.2022.
//

import UIKit
import FirebaseDatabase
import ReverseExtension


class DialogViewController: UIViewController {
    let myuid = Storage.sharedInstance.my_uid
    
    var user = User()
    
    @IBOutlet weak var dialogTableView: UITableView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dialogTableView.allowsSelection = false
        configure()
        parseMessages()
        dialogTableView.re.delegate = self
        dialogTableView.re.dataSource = self
    }
    
    @IBAction func changeSendButton(_ sender: Any) {
        if messageTextField.text == ""{
            sendButton.alpha = 0.5
            sendButton.isEnabled = false
        }else{
            sendButton.alpha = 1
            sendButton.isEnabled = true
        }
    }
    
    @IBAction func sendTapped(_ sender: Any){
        sendMessage()
        messageTextField.text = ""
    }
    
    private func sendMessage(){
        let message = messageTextField.text!
        
        let ref = Database.database().reference()
        let newMessageRef = ref
                              .child("users")
                              .child(myuid)
                              .child("chats")
                              .child(user.id)
                              .childByAutoId()
        
        let friendMessageRef = ref
                              .child("users")
                              .child(user.id)
                              .child("chats")
                              .child("\(myuid)")
                              .child(newMessageRef.key!)
        
        let lastMessageRef = ref
                              .child("users")
                              .child(myuid)
                              .child("chats")
                              .child("last_message")
                              .child(user.id)

        let lastFriendMessageRef = ref
                                  .child("users")
                                  .child(user.id)
                                  .child("chats")
                                  .child("last_message")
                                  .child(myuid)
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let lastMessageData = [
          "text": message,
          "sender": myuid,
          "time": formatter.string(from: currentDateTime),
          "name": UserDefaults.standard.string(forKey: "name"),
          "avatar": UserDefaults.standard.string(forKey: "avatarID")
        ]
        
        let myLastMessageData = [
          "text": message,
          "sender": user.id,
          "time": formatter.string(from: currentDateTime),
          "name": user.name,
          "avatar": user.avatarID
        ]
        
        print(myLastMessageData["sender"])
        print(lastMessageData["sender"])
        let newMessageData = [
          "text": message,
          "sender": myuid,
          "time": formatter.string(from: currentDateTime)
        ]
        
        lastFriendMessageRef.setValue(lastMessageData)
        lastMessageRef.setValue(myLastMessageData)
        
        friendMessageRef.setValue(newMessageData)
        newMessageRef.setValue(newMessageData)
    }
    
    private func configure(){
        getData(from: URL(string: "https://avatars.dicebear.com/api/micah/\(user.avatarID).png")!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.avatarImage.image = UIImage(data: data)
            }
        }
        self.avatarImage.layer.cornerRadius = 23
        nameLabel.text = user.name
        if user.status == true{
            self.statusLabel.text = "online"
        }else{
            self.statusLabel.text = "offline"
        }
    }
    
    private func parseMessages(){
        let ref = Database.database().reference()
        ref
            .child("users")
            .child(myuid)
            .child("chats")
            .child(user.id)
            .observe(.value, with: { snapshot in
                self.messages.removeAll()
                for item in snapshot.children {
                    guard let item = item as? DataSnapshot else {
                        break
                    }
                    if let dict = item.value as? [String: Any]{
                        if let text = dict["text"] as? String, let time = dict["time"] as? String, let sender = dict["sender"] as? String{
                            if sender == self.myuid{
                                self.messages.append(Message(text: text, sender: true, time: time))
                            }else{
                                self.messages.append(Message(text: text, sender: false, time: time))
                            }
                        }
                    }
                }
                self.dialogTableView.reloadData()
            })
    }
}

extension DialogViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].sender == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessageTableViewCell", for: indexPath) as! FriendMessageTableViewCell
            cell.messageTextLabel.text = messages[indexPath.row].text
            cell.timeLabel.text = String(messages[indexPath.row].time.suffix(8).prefix(5))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
            cell.messageTextLabel.text = messages[indexPath.row].text
            cell.timeLabel.text = String(messages[indexPath.row].time.suffix(8).prefix(5))
            return cell
        }
    }
}
