//
//  AppDelegate.swift
//  Notification
//
//  Created by guanho on 2016. 12. 20..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(setting)
        //알림 등록
        
        
        if let localNoti = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification{
            print((localNoti.userInfo))
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if #available(iOS 10.0, *){
            let setting = application.currentUserNotificationSettings
            guard setting?.types != .none else{
                print("Can't Schedule")
                return
            }
            
            let nContent = UNMutableNotificationContent()
            
            nContent.badge = 1
            nContent.body = "들어와~"
            nContent.title = "하하하"
            nContent.subtitle = "ㅋㅋㅋㅋ"
            nContent.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
        }else{
            let setting = application.currentUserNotificationSettings
            //정보 가져옴
            guard setting?.types != .none else{
                print("Can't Schedule")
                return
            }
            
            let noti = UILocalNotification()
            
            noti.fireDate = Date(timeIntervalSinceNow: 5)  // 5초후 발송
            noti.timeZone = TimeZone.autoupdatingCurrent  // 현재 위치에 따라 타임존 설정
            noti.alertBody = "다시 접속!" // 메시지
            noti.alertAction = "잠금 해제"  // 잠금 상태일 때 표시
            noti.applicationIconBadgeNumber = 1  // 모서리
            noti.soundName = UILocalNotificationDefaultSoundName  // 사운드
            noti.userInfo = ["name":"가나다"]  // 로컬 알림 실행시 함꼐 전달하고 싶은 값
            
            application.scheduleLocalNotification(noti)
            //등록
            
            //application.presentLocalNotificationNow(noti)
            //즉각 발송
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print(notification.userInfo)
        
        if application.applicationState == UIApplicationState.active{
            //앱 활성화중
        }else if application.applicationState == .inactive{
            //비활성화중
        }
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















//
//
////
////  AppDelegate.swift
////  Notification
////
////  Created by guanho on 2016. 12. 20..
////  Copyright © 2016년 guanho. All rights reserved.
////
//
//import UIKit
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(setting)
//        //알림 등록
//        
//        
//        if let localNoti = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification{
//            print((localNoti.userInfo))
//        }
//        
//        
//        return true
//    }
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        
//        if #available(iOS 11.0, *){
//            
//        }else{
//            let setting = application.currentUserNotificationSettings
//            //정보 가져옴
//            guard setting?.types != .none else{
//                print("Can't Schedule")
//                return
//            }
//            
//            let noti = UILocalNotification()
//            
//            noti.fireDate = Date(timeIntervalSinceNow: 5)  // 5초후 발송
//            noti.timeZone = TimeZone.autoupdatingCurrent  // 현재 위치에 따라 타임존 설정
//            noti.alertBody = "다시 접속!" // 메시지
//            noti.alertAction = "잠금 해제"  // 잠금 상태일 때 표시
//            noti.applicationIconBadgeNumber = 1  // 모서리
//            noti.soundName = UILocalNotificationDefaultSoundName  // 사운드
//            noti.userInfo = ["name":"가나다"]  // 로컬 알림 실행시 함꼐 전달하고 싶은 값
//            
//            application.scheduleLocalNotification(noti)
//            //등록
//            
//            //application.presentLocalNotificationNow(noti)
//            //즉각 발송
//        }
//    }
//
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        print(notification.userInfo)
//        
//        if application.applicationState == UIApplicationState.active{
//            //앱 활성화중
//        }else if application.applicationState == .inactive{
//            //비활성화중
//        }
//    }
//    
//    
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//
//
//}

