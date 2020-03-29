//
//  AppDelegate.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var router: IRouter = Router.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.makeWindow()
        
        return true
    }
}

extension AppDelegate {
    
    func makeWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = self.router.rootViewController()
        self.window?.makeKeyAndVisible()
    }
}

