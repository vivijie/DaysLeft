//
//  AppDelegate.swift
//  DaysLeft
//
//  Created by viviJIE on 8/27/17.
//  Copyright © 2017 tdones. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack(modelName: "DaysLeft")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    customizeAppearance()

    guard let navController = window?.rootViewController as? UINavigationController,
      let viewController = navController.topViewController as? BigDaysTableViewController else {
        return true
    }
    
    viewController.managedContext = coreDataStack.managedContext
    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    coreDataStack.saveContext()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  func customizeAppearance() {
    let barTintColorP3 = UIColor(displayP3Red: 40/255, green: 122/255, blue: 212/255, alpha: 1)
    UINavigationBar.appearance().barTintColor = barTintColorP3
    
    // Change title color
    let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
    UINavigationBar.appearance().titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
    UIBarButtonItem.appearance().tintColor = UIColor(white: 1.0, alpha: 1.0)
    window!.tintColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
    
  }
}


