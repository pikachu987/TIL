//
//  ViewController.swift
//  GoogleLogin
//
//  Created by guanho on 2016. 9. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var googleInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //googleAuth
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.ctrl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //구글 로그인 콜백
    func  googleActionCallback(email: String, name: String){
        print("name : \(name)")
        print("email : \(email)")
    }
}

