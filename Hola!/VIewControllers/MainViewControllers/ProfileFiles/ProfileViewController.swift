//
//  ProfileViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 01.05.2022.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let images = [UIImage(systemName: "person.crop.square") , UIImage(systemName: "square.and.pencil"), UIImage(systemName: "arrow.backward.square")]
    let buttons = ["My data", "Write to support", "Leave"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.iconImage.image = images[indexPath.row]
        cell.nameLabel.text = buttons[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "myDataViewController") as! myDataViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1: UIApplication.shared.open(URL(string: "https://t.me/gazizovna_sabina")!)
        case 2: showLogoutPage()
            
        default:
            print()
        }
    }
    
    private func showLogoutPage(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        mainViewController.modalPresentationStyle = .overFullScreen
        self.present(mainViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ProfileHeaderView.instantiate()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 248.0
    }
    
}
