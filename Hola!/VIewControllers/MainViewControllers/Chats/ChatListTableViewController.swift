//
//  ChatListTableViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 01.05.2022.
//

import UIKit
import FirebaseDatabase


class ChatListTableViewController: UITableViewController {
    let myuid = Storage.sharedInstance.my_uid
    
    var dialogs = [Dialog]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseMessages()
    }
    
    private func parseMessages(){
        
        let ref = Database.database().reference()
        ref
            .child("users")
            .child(myuid)
            .child("chats")
            .child("last_message")
            .observe(.value, with: { snapshot in
                self.dialogs.removeAll()
                for item in snapshot.children {
                    guard let item = item as? DataSnapshot else {
                        break
                    }
                    if let dict = item.value as? [String: Any]{
                        print("dictionary: \(dict)")
                        if let message = dict["text"] as? String,
                            let time = dict["time"] as? String,
                            let sender = dict["sender"] as? String,
                            let name = dict["name"] as? String,
                            let avatarID = dict["avatar"] as? String{
                            if sender == self.myuid{
                                self.dialogs.append(Dialog(avatarID: avatarID, name: name, message: message, time: time, count: 0, sender: true))
                                self.users.append(User(id: sender, name: name, avatarID: avatarID, status: true))
                            }else{
                                self.dialogs.append(Dialog(avatarID: avatarID, name: name, message: message, time: time, count: 0, sender: false))
                                self.users.append(User(id: sender, name: name, avatarID: avatarID, status: true))
                            }
                        }
                    }
                }
            self.users = self.users.reversed()
            self.dialogs = self.dialogs.reversed()
            self.tableView.reloadData()
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.usernameLabel.text = dialogs[indexPath.row].name
        cell.messagetextLabel.text = dialogs[indexPath.row].message
        getData(from: URL(string: "https://avatars.dicebear.com/api/micah/\(dialogs[indexPath.row].avatarID).png")!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.avatarImageView.image = UIImage(data: data)
            }
        }
        cell.unreadCountView.isHidden = true
        cell.countOfMessagesLabel.text = String(dialogs[indexPath.row].count)
        cell.sendTimeLabel.text = String(dialogs[indexPath.row].time.suffix(8).prefix(5))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        let vc = storyboard?.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
        vc.user = users[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
}
