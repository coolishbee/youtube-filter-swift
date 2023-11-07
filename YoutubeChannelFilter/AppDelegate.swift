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
        
        let config = APIConfiguration(apiKey: "AIzaSyAQyLxX7ZxjnURAvRY-HgYsrIcrFuHqWKE")
        APIConfiguration._shared = config
        
//        let tabBarController = UITabBarController()
//        let homeVC = HomeViewController()
//        //let resultVC = ResultListViewController()
//        let myPageVC = MyPageViewController()
//
//        homeVC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
//        //resultVC.tabBarItem = UITabBarItem.init(title: "Result", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
//        myPageVC.tabBarItem = UITabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
//
//        let t1 = UINavigationController(rootViewController: homeVC)
//        let t2 = UINavigationController(rootViewController: myPageVC)
//
//        tabBarController.viewControllers = [t1, t2]
//        self.window?.rootViewController = tabBarController
        
        let tabBarController = UITabBarController()
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: MyPageViewController())

        tabBarController.setViewControllers([firstVC, secondVC], animated: true)

        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(named: "home_1")
            items[0].image = UIImage(named: "home")
            items[0].title = "Home"
            items[1].selectedImage = UIImage(named: "me_1")
            items[1].image = UIImage(named: "me")
            items[1].title = "Me"
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
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

