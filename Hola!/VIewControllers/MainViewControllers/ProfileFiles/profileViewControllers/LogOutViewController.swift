//
//  LogOutViewController.swift
//  foody-client
//
//  Created by Sanzhar Koshkarbayev on 25.04.2022.
//

import UIKit

class LogOutViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var logoutButton: ActualGradientButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = gradientColor1.cgColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        UIView.animate(withDuration: 1.0) {
            self.backgroundView.alpha = 0.3
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        changeStatus(false)
        UserDefaults.standard.removeObject(forKey: "user_uid")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "avatarID")
        self.showAuth()
    }
    
    func showAuth(){
        let storyboard = UIStoryboard(name: "AuthStoryboard", bundle: nil)
        let destController = storyboard.instantiateViewController(withIdentifier: "AuthVC")
        destController.modalTransitionStyle = .crossDissolve
        destController.modalPresentationStyle = .fullScreen
        self.present(destController, animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismissView()
    }
}

extension LogOutViewController{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: contentView))! {
            return false
        }
        return true
    }
    @objc func dismissView() {
        self.backgroundView.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }
}
