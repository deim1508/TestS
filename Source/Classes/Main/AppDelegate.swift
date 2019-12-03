//
//  AppDelegate.swift
//  events
//
//  Created by halcyon on 12/11/18.
//  Copyright © 2018 halcyon. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var flow: RootFlowController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        flow = RootFlowController(window: window)
        flow?.start()
        Theme.dark.apply()
      
        return true
    }
}

