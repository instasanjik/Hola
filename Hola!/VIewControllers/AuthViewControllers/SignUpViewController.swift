//
//  SignUpViewController.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 01.05.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var nameTextField: TextFieldWithPadding!
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passwordTextField: TextFieldWithPadding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let name = nameTextField.text!
        self.checkUserNameAlreadyExist(newUserName: name, completion: { isExist in
            if isExist {
                SVProgressHUD.showError(withStatus: "Your username must have been unique, the user named \"\(name)\" is already registered!")
                SVProgressHUD.dismiss(withDelay: 5)
            }
            else{
                let email = self.emailTextField.text!
                let password = self.passwordTextField.text!
                if name == "" || email == "" || password == ""{
                    SVProgressHUD.showError(withStatus: "Enter all fields!")
                    SVProgressHUD.dismiss(withDelay: 2)
                }else{
                    Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                        if error == nil{
                            if let result = result{
                                let randAvatar = Int.random(in: 0...10000)
                                let ref = Database.database().reference().child("users")
                                
                                ref.child(result.user.uid).updateChildValues(["name" : name])
                                ref.child(result.user.uid).updateChildValues(["avatarID" : String(randAvatar)])
                                UserDefaults.standard.set(result.user.uid, forKey: "user_uid")
                                changeStatus(true)
                                UserDefaults.standard.set(name, forKey: "name")
                                UserDefaults.standard.set(String(randAvatar), forKey: "avatarID")
                                self.activate()
                            }
                        }else{
                            print("soso")
                            SVProgressHUD.showError(withStatus: "Check the correctness of the entered data!")
                            SVProgressHUD.dismiss(withDelay: 2)
                        }
                    }
                }
            }
        })
        
    }
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void) {
        let ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "name").queryEqual(toValue: newUserName)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if snapshot.exists() {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }
    
    private func activate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        tabbarVC.modalPresentationStyle = .fullScreen
        tabbarVC.modalTransitionStyle = .flipHorizontal
        self.present(tabbarVC, animated: true, completion: nil)
    }
}
