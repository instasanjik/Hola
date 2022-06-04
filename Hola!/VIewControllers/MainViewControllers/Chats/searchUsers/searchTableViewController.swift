//
//  searchTableViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 20.05.2022.
//

import UIKit
import FirebaseDatabase


class searchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.searchQueryUsers(text: searchText)
            })
        }
    }

    func searchQueryUsers(text: String) -> Void {
        let ref = Database.database().reference()
        users.removeAll()
        ref.child("users").queryOrdered(byChild: "name").queryEqual(toValue: text).observeSingleEvent(of: .value, with: { snapshot in
            for item in snapshot.children {
                guard let item = item as? DataSnapshot else {
                    break
                }
                if let dict = item.value as? [String: Any]{
                    if let name = dict["name"] as? String, let avatarID = dict["avatarID"] as? String, let status = dict["status"] as? Bool{
                        self.users.append(User(id: item.key, name: name, avatarID: avatarID, status: status))
                    }
                }
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchProfileTableViewCell", for: indexPath) as! searchProfileTableViewCell
        getData(from: URL(string: "https://avatars.dicebear.com/api/micah/\(users[indexPath.row].avatarID).png")!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.avatarImage.image = UIImage(data: data)
            }
        }
        cell.usernameLabel.text = users[indexPath.row].name
        if users[indexPath.row].status == true{
            cell.statusLabel.text = "online"
        }else{
            cell.statusLabel.text = "offline"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
        vc.user = users[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
