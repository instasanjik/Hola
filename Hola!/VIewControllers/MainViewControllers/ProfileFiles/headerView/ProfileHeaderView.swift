//
//  ProfileHeaderView.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 12.05.2022.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD

class ProfileHeaderView: UIView {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoText: UILabel!
    
    static func instantiate() -> ProfileHeaderView {
        let view: ProfileHeaderView = initFromNib()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        let avatarID = UserDefaults.standard.string(forKey: "avatarID") ?? ""
        view.avatarImage.layer.borderColor = UIColor("33BEE7").cgColor
        view.nameLabel.text = name
        view.getData(from: URL(string: "https://avatars.dicebear.com/api/micah/\(avatarID).png")!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                view.avatarImage.image = UIImage(data: data)
            }
        }
        
        return view
    }
    
    var tap = 1
    
    @IBAction func avatarTapped(_ sender: UIButton) {
        SVProgressHUD.showProgress(Float(tap)*0.33)
        SVProgressHUD.dismiss(withDelay: 1)
        tap += 1
        
        if tap==4{
            tap = 1
            let randAvatar = Int.random(in: 0...10000)
            
            let ref = Database.database().reference().child("users")
            ref.child(
                Storage.sharedInstance.my_uid).updateChildValues(["avatarID" : String(randAvatar)])
            UserDefaults.standard.set(String(randAvatar), forKey: "avatarID")
            getData(from: URL(string: "https://avatars.dicebear.com/api/micah/\(randAvatar).png")!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.avatarImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}


extension UIView {
    class func initFromNib<T: UIView>() -> T{
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}
