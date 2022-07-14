//
//  ViewController.swift
//  Top100
//
//  Created by William Rodriguez on 7/7/22.
//
//

import Foundation
import UIKit
import RealmSwift
import Combine

class AlbumListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let userRealm: Realm
    //let tasks: Results<Task>
    
    var notificationToken: NotificationToken?
    
    var top100AlbbumsViewModel: Top100AlbumsViewModel
    private var cancellable: AnyCancellable?
    private let refreshControl = UIRefreshControl()
    
    init(userRealmConfiguration: Realm.Configuration, collectionViewLayout: UICollectionViewLayout) {
        self.userRealm = try! Realm(configuration: userRealmConfiguration)
        self.top100AlbbumsViewModel = Top100AlbumsViewModel()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.title = "Top 100 Albums"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tag: Set Navigation Bar Appearance
        navigationItem.largeTitleDisplayMode = .automatic
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
        ]
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
        ]
        
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance


        // Initialize collection view
        self.collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .white
        self.collectionView.isPrefetchingEnabled = false
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.indicatorStyle = .white
        self.collectionView.setCollectionViewLayout(AlbumCollectionViewLayout(), animated: true)
        
        cancellable = top100AlbbumsViewModel.objectWillChange.sink { [weak self] in
            //self?.refreshCollectionView()
            switch self?.top100AlbbumsViewModel.state {
            case .isWaiting:
                // Show loading spinner
                // debugPrint("iswaiting")
                break
            case .isLoading:
                // Show loading spinner
                // debugPrint("isloading")
                break
            case .didFail(let error):
                // Show error view
                debugPrint("didFail \(error)")
                break
            case .didLoad:
                // Show user's profile
                //debugPrint("didLoad")
                self?.collectionView.reloadData()
            case .networkUnavailable:
                // debugPrint("networkUnavailable")
                break
            case .none:
                // debugPrint("none")
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        top100AlbbumsViewModel.load()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let albumCount = top100AlbbumsViewModel.top100AlbumsFeed?.results.count ?? 0
    
        return albumCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell
        else { preconditionFailure("Failed to load collection view cell") }
        

        cell.albumId = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].id ?? UUID().uuidString
        cell.albumName = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name ?? "Unknown"
        cell.albumNameLBL.text = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name ?? "Unknown"
        //cell.albumNameLBL.text = "This is a long name to see what happens when we word wrap"
        cell.artistId = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistId ?? UUID().uuidString
        cell.artistName = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName ?? "Unknown"
        cell.artistNameLBL.text = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName ?? "Unknown"
        
        if let URLString = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artworkUrl100 {
            if let url = NSURL(string: URLString)  {
                ImageLoader.shared.loadImage(imageURL: url, completion: {image -> Void in
                    cell.albumImageView.image = image
                })
            }
        }
                                                                                                      
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albumImageURL = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artworkUrl100 else { return }
        guard let albumURL = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].url else { return }
        let albumId = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].id ?? ""
        guard let albumName = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name else { return }
        let artistId = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistId ?? ""
        guard let artistName = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName else { return }
        guard let releaseDate = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].releaseDate else { return }
        guard let copyright = top100AlbbumsViewModel.top100AlbumsFeed?.copyright else { return }
        guard let genres = top100AlbbumsViewModel.top100AlbumsFeed?.results[indexPath.row].genres else { return }
        let vc = AlbumDetailViewController(albumImageURL: albumImageURL, albumURL: albumURL, albumId:albumId, albumName: albumName, artistId: artistId, artistName: artistName, releaseDate: releaseDate, copyright: copyright, genres: genres)

        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width - 24)/2), height: ((collectionView.frame.size.width - 24)/2))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

    }

}

