//
//  AppDelegate.swift
//  Top100
//
//  Created by William Rodriguez on 7/7/22.
//
//

import UIKit
import RealmSwift

 @main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        var config = Realm.Configuration.defaultConfiguration
        // This configuration step is not really needed, but if we add Sync later,
        // this allows us to keep the tasks we made.
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent("project=Top100")
        config.fileURL!.appendPathExtension("realm")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: AlbumListViewController(userRealmConfiguration: config, collectionViewLayout: UICollectionViewFlowLayout()))
        
        return true
    }

}

