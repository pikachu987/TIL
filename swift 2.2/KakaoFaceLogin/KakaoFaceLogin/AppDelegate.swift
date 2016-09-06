//
//  AppDelegate.swift
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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //firebase
        FIRApp.configure()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        //kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        }
        return false
    }
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }


}

