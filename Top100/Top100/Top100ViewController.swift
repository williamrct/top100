//
//  ViewController.swift
//  Top100
//
//  Created by William Rodriguez on 7/7/22.
//

import Foundation
import UIKit
import RealmSwift

class Top100ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let top100CollectionView = UICollectionView()
    let userRealm: Realm
    var userData: User?
    var notificationToken: NotificationToken?

    init(userRealmConfiguration: Realm.Configuration) {
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: deinit method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        title = "Top 100 Albums"
        top100CollectionView.dataSource = self
        top100CollectionView.delegate = self
        top100CollectionView.frame = self.view.frame
        view.addSubview(top100CollectionView)
        
        // On the top left is a log out button.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonDidClick))
    }
    
    @objc func logOutButtonDidClick() {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
            _ -> Void in
            print("Logging out...")
            self.navigationController?.popViewController(animated: true)
            // TODO: log out the current user
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }


}

