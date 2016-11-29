//
//  AppDelegate.swift
//  ForceTouch
//
//  Created by guanho on 2016. 11. 28..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty{
            let shortcutFirst = UIMutableApplicationShortcutItem(type: "FirstTab", localizedTitle: "Show Info", localizedSubtitle: "Show all info", icon: UIApplicationShortcutIcon(type: .contact), userInfo: nil)
            let shortcutSecond = UIMutableApplicationShortcutItem(type: "SecondTab", localizedTitle: "Get List", localizedSubtitle: "Get all item list", icon: UIApplicationShortcutIcon(type: .bookmark), userInfo: nil)
            
            application.shortcutItems = [shortcutFirst, shortcutSecond]
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let performedShortCutItem = self.performedShortCutItem(shortcutItem)
        completionHandler(performedShortCutItem)
    }
    
    
    func performedShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool{
        var performed = false
        var tabIndex = 0
        
        guard let shortcutType = shortcutItem.type as String? else {return false}
        
        switch(shortcutType){
            case "FirstTab":
            performed = true
            tabIndex = 0
            break
            case "SecondTab":
            performed = true
            tabIndex = 1
            break
        case "Shortcut1":
            performed = true
            tabIndex = 0
            break
        case "Shortcut2":
            performed = true
            tabIndex = 1
            break
        default:
            break
        }
        
        if performed{
            if let tabBarController =  self.window!.rootViewController as? UITabBarController{
                tabBarController.selectedIndex = tabIndex
            }
        }
        
        return performed
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

