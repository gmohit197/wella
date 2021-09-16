//
//  AppDelegate.swift
//  Wella.2
//
//  Created by Acxiom on 19/08/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging
import UserNotificationsUI
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    static var menubool = true
    static var index = 0;
    static var calendar = true
    static var mobilenumber: String?
    static var ntwrk = 0;
    static var DATABASE_VERSION: Int16!
    static var Modelname = UIDevice.modelName
    static var isDebug = true
    static var isDownloadClick = false
    static var salonCodeSalonTracking : String! = ""
    static  var isIntentDone : String! = "0"
    static var calendardate  : Date!
    static var calendarevent  : String! = ""
     static var selectedText  : String! = ""
     static var palnnedcalendardate  : String!
     static var impactDateCalendar  : String!
     static  var isRetryDone : String! = "0"
    
//   var restrictRotation:UIInterfaceOrientationMask = .all
//    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
//    {
//        return self.restrictRotation
//    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
            var navigationBarAppearace = UINavigationBar.appearance()
            navigationBarAppearace.tintColor = UIColor.myControlBackground
            navigationBarAppearace.barTintColor = UIColor.myControlBackground
            

        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
//
//            if err != nil {
//                //something bad happened
//            }
//            else
//            {
//                UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
//                Messaging.messaging().delegate = self
//
//
//                    UIApplication.shared.registerForRemoteNotifications()
//                    FirebaseApp.configure()
//
//            }
//        }

        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
         IQKeyboardManager.shared.enable = true
         return true
    }
    
    
    func ConnectToFCM()
    {
    //    Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
     //   Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    //    ConnectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        let newToken = InstanceID.instanceID().token(withAuthorizedEntity: <#String#>, scope: <#String#>, handler: <#InstanceIDTokenHandler#>)
//        //print(" insert=====newToken: \(String(describing: newToken))")
//        ConnectToFCM()
//    }

}

extension UIColor {
    static var myControlBackground: UIColor {
        return UIColor(red: 175/255.0, green: 110/255.0, blue: 150/255.0, alpha: 1)
    }
}

