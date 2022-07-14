//
//  ViewController.swift
//  Top100
//
//  Created by William Rodriguez on 7/7/22.
//

import Foundation
import UIKit
import RealmSwift

class Top100ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //private let top100CollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let userRealm: Realm
    //let tasks: Results<Task>
    
    var notificationToken: NotificationToken?
    

    init(userRealmConfiguration: Realm.Configuration, collectionViewLayout: UICollectionViewLayout) {
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        //super.init(nibName: nil, bundle: nil)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.title = "Top 100 Albums"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: deinit method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top 100 Albums"
        
        self.collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
        self.collectionView.register(Top100HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Top100HeaderCollectionReusableView.identifier)
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.frame = self.view.frame
        self.collectionView.backgroundColor = .white
        
        // On the top left is a log out button.
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonDidClick))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.prefersLargeTitles = true
            self?.navigationController?.navigationBar.sizeToFit()
        }
              
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
    
    
    /*override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //if kind == UICollectionView.elementKindSectionHeader {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Top100HeaderCollectionReusableView.identifier, for: indexPath)
        return header
        //}
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
 
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.width/2)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2 - 2), height: (view.frame.size.width/2 - 2))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

}

