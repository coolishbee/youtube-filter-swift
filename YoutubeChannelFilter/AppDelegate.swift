//
//  AppDelegate.swift
//  YoutubeChannelFilter
//
//  Created by coolishbee on 2023/07/03.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = APIConfiguration(apiKey: "AIzaSyCnR0O_UIaepOwVyYnQF78XTTX5E2qz0yQ")
        APIConfiguration._shared = config
                
                
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = MainTabBarVC()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        print("WillResignActive")
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("DidEnterBackground")
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("WillEnterForeground")
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("DidBecomeActive")
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        print("WillTerminate")
//        //self.saveContext()
//    }
    
}

