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
    @IBOutlet var image2View: UIImageView!
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
                            //String(kakao.ID)
                            if let value = kakao.properties["nickname"] as? String{
                                self.textView.text = "nickname : \(value)\r\n"
                            }
                            if let value = kakao.properties["profile_image"] as? String{
                                self.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: value)!)!)
                            }
                            if let value = kakao.properties["thumbnail_image"] as? String{
                                self.image2View.image = UIImage(data: NSData(contentsOfURL: NSURL(string: value)!)!)
                            }
                        })
                    }
                })
            }else{
                print("isNotOpen")
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

