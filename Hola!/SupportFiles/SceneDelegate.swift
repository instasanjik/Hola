//
//  SceneDelegate.swift
//  Hola!
//
//  Created by Sanzhar Koshkarbayev on 01.05.2022.
//

import UIKit
import FirebaseDatabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if UserDefaults.standard.string(forKey: "user_uid") != nil{
            print(UserDefaults.standard.string(forKey: "user_uid"))
            fillStorage()
            activate()
            changeStatus(true)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func activate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        window?.rootViewController = newVC
        window?.makeKeyAndVisible()
    }
    
    func fillStorage(){
        Storage.sharedInstance.my_uid = UserDefaults.standard.string(forKey: "user_uid") ?? ""
        Storage.sharedInstance.name = UserDefaults.standard.string(forKey: "name") ?? "Unknown"
        Storage.sharedInstance.avatar_id = UserDefaults.standard.string(forKey: "avatarID") ?? "default"
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        changeStatus(true)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        changeStatus(true)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        changeStatus(false)
    }

    func changeStatus(_ status: Bool){
        if Storage.sharedInstance.my_uid != ""{
            let ref = Database.database().reference().child("users")
            ref.child(Storage.sharedInstance.my_uid).updateChildValues(["status" : status])
        }
    }
}

