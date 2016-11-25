//
//  ViewController.swift
//  LoginF
//
//  Created by guanho on 2016. 9. 8..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    //페이스북 로그인 클릭
    @IBAction func facebookAction(sender: AnyObject) {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { (result, error) in
            if error != nil{
                print("Facebook login failed. Error \(error)")
            } else if result.isCancelled {
                print("Facebook login isCancelled. result \(result.token)")
            } else {
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        if let value = user?.email{
                            self.textView.text = "email : \(value)\r\n"
                        }
                        if let value = user?.displayName{
                            self.textView.text = self.textView.text+"displayNmae : \(value)\r\n"
                        }
                        if let value = user?.uid{
                            //
                        }
                        if let value = user?.photoURL{
                            self.imageView.image = UIImage(data: NSData(contentsOfURL: value)!)
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

