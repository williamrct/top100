//
//  SceneDelegate.swift
//  Top100
//
//  Created by William Rodriguez on 7/8/22.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        var config = Realm.Configuration.defaultConfiguration
        // This configuration step is not really needed, but if we add Sync later,
        // this allows us to keep the tasks we made.
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent("project=Top100")
        config.fileURL!.appendPathExtension("realm")

        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: Top100ViewController(userRealmConfiguration: config))
    }
}
