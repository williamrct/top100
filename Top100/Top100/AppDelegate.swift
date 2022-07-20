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
        
        let config = Realm.Configuration.defaultConfiguration
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: AlbumListViewController(realmConfiguration: config, collectionViewLayout: UICollectionViewFlowLayout()))
        
        return true
    }

}

