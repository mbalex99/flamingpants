//
//  AppDelegate.swift
//  FlamingPants
//
//  Created by Maximilian Alexander on 7/24/15.
//  Copyright (c) 2015 Epoque. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var startingViewController = ViewController()
        
        window?.rootViewController = startingViewController
        window?.makeKeyAndVisible()
        return true
    }

}

