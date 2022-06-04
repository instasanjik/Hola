//
//  LoginViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 01.05.2022.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField: TextFieldWithPadding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        SVProgressHUD.show()
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email == "" || password == ""{
            SVProgressHUD.showError(withStatus: "Enter all fields!")
            SVProgressHUD.dismiss(withDelay: 2)
        }else{
            Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
                if error == nil{
                    SVProgressHUD.dismiss()
                    let uid = result!.user.uid
                    UserDefaults.standard.set(uid, forKey: "user_uid")
                    let ref = Database.database().reference()
                    ref.child("users/\(uid)/name").getData(completion:  { error, snapshot in
                      guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                      }
                        let name = snapshot?.value as? String ?? "Unknown";
                        UserDefaults.standard.set(name, forKey: "name")
                    });
                    ref.child("users/\(uid)/avatarID").getData(completion:  { error, snapshot in
                      guard error == nil else {
                        print(error!.localizedDescription)
                        return;
                      }
                        let avatarID = snapshot?.value as? String ?? String(Int.random(in: 0...10000));
                        UserDefaults.standard.set(avatarID, forKey: "avatarID")
                    });
                    changeStatus(true)
                    self.activate()
                }else if (error!.localizedDescription == "The password is invalid or the user does not have a password."){
                    SVProgressHUD.showError(withStatus: "Incorrect email or password.")
                    SVProgressHUD.dismiss(withDelay: 2)
                }else{
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
        }
    }
    private func activate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        tabbarVC.modalPresentationStyle = .fullScreen
        tabbarVC.modalTransitionStyle = .flipHorizontal
        self.present(tabbarVC, animated: true, completion: nil)
    }
}
