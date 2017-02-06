//
//  AppDelegate.swift
//  Flickz
//
//  Created by Enzo Ames on 2/3/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Dont need to create a new view controller. Programmatically create each tab bar controller. The Tab bar controller is the first thing in the app. App Delagate. is the first thing that happens when the app begins
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        //NOW_PLAYING///
        
        //We basically built a now_playing Navigation controller by referencing the blue-print in the storyBoard, for the NavigationController, moviesNavigationController
        
        let nowPlayingNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        let nowPLayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPLayingViewController.endPoint = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "now_playing")
        
        
        //TOP_RATED
        
        let topRatedNavigationController = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endPoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "top_rated")
        
        
        
        
        //CREATING A TAP BAR CONTROLLER
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
        tabBarController.tabBar.barTintColor = UIColor.init(red: 142.0/255.0, green: 35.0/255.0, blue: 35.0/255.0, alpha: 200.0)
        tabBarController.tabBar.selectedItem?.badgeColor = UIColor.darkGray
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        
        return true
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

