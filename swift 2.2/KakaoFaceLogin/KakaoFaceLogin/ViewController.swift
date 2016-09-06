//
//  ViewController.swift
//  KakaoFaceLogin
//
//  Created by guanho on 2016. 9. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func kakaoAction(sender: AnyObject) {
        let session: KOSession = KOSession.sharedSession();
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.openWithCompletionHandler({ (error) -> Void in
            if error != nil{
                print(error.localizedDescription)
            }else if session.isOpen() == true{
                KOSessionTask.meTaskWithCompletionHandler({ (profile , error) -> Void in
                    if profile != nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let kakao : KOUser = profile as! KOUser
                            var nickName = ""
                            if let kakaoNickname = kakao.properties["nickname"] as? String{
                                nickName = kakaoNickname
                            }
                            print(String(kakao.ID))
                            print(nickName)
                        })
                    }
                })
            }else{
                print("isNotOpen")
            }
        })
    }
    
    @IBAction func fbAction(sender: AnyObject) {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { (result, error) in
            if error != nil{
                print("Facebook login failed. Error \(error)")
            } else if result.isCancelled {
                print("Facebook login isCancelled. result \(result.token)")
            } else {
                //let credential = FIRFacebookAuthProvider.credentialWithAccessToken(result.token.tokenString)
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged in!")
                        print("user:\(user)")
                        print("displayName:\(user?.displayName)")
                        print("email:\(user?.email)")
                        print("prov:\(user?.providerID)")
                        print("uid:\(user?.uid)")
                        print("proData:\(user?.providerData)")
                    }
                }
            }
        })
    }
}

