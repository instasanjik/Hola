//
//  myDataViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 23.05.2022.
//

import UIKit

class myDataViewController: UIViewController {
    let images: [UIImage] = [UIImage(systemName: "person.crop.square.fill")!,
                             UIImage(systemName: "photo.fill.on.rectangle.fill")!,
                             UIImage(systemName: "key.fill")!]
    let info: [String] = ["name: \(Storage.sharedInstance.name)",
                          "avatar id: \(Storage.sharedInstance.avatar_id)",
                          "uid: \(Storage.sharedInstance.my_uid)"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension myDataViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myDataTableViewCell", for: indexPath) as! myDataTableViewCell
        cell.ImageView.image = images[indexPath.row]
        cell.nameLabel.text = info[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
