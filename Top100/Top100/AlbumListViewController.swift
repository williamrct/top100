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

    var notificationToken: NotificationToken?
    
    var top100AlbumsViewModel: Top100AlbumsViewModel
    private var cancellable: AnyCancellable?
    private let refreshControl = UIRefreshControl()

    init(realmConfiguration: Realm.Configuration, collectionViewLayout: UICollectionViewLayout) {
        self.top100AlbumsViewModel = Top100AlbumsViewModel(realmConfiguration: realmConfiguration)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.title = "Top 100 Albums"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tag: Set Navigation Bar Appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ]
        
        navigationController?.navigationBar.isOpaque = true
        
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 34)
        ]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        

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
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        
        cancellable = top100AlbumsViewModel.objectWillChange.sink { [weak self] in
            //self?.refreshCollectionView()
            switch self?.top100AlbumsViewModel.state {
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
        top100AlbumsViewModel.load()
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        top100AlbumsViewModel.load()
        refreshControl.endRefreshing()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let albumCount = top100AlbumsViewModel.top100AlbumsFeed?.results.count ?? 0
    
        return albumCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell
        else { preconditionFailure("Failed to load collection view cell") }
        

        cell.albumId = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].id ?? UUID().uuidString
        cell.albumName = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name ?? "Unknown"
        cell.albumNameLBL.text = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name ?? "Unknown"
        //cell.albumNameLBL.text = "This is a long name to see what happens when we word wrap"
        cell.artistId = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistId ?? UUID().uuidString
        cell.artistName = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName ?? "Unknown"
        cell.artistNameLBL.text = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName ?? "Unknown"
        
        if let URLString = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artworkUrl100 {
            if let url = NSURL(string: URLString)  {
                top100AlbumsViewModel.loadImage(imageURL: url, completion: {image -> Void in
                    cell.albumImageView.image = image
                })
            }
        }
                                                                                                      
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let albumImageURL = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artworkUrl100 else { return }
        guard let albumURL = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].url else { return }
        let albumId = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].id ?? ""
        guard let albumName = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].name else { return }
        let artistId = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistId ?? ""
        guard let artistName = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].artistName else { return }
        guard let releaseDate = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].releaseDate else { return }
        guard let copyright = top100AlbumsViewModel.top100AlbumsFeed?.copyright else { return }
        guard let genres = top100AlbumsViewModel.top100AlbumsFeed?.results[indexPath.row].genres else { return }
        let vc = AlbumDetailViewController(albumImageURL: albumImageURL, albumURL: albumURL, albumId:albumId, albumName: albumName, artistId: artistId, artistName: artistName, releaseDate: releaseDate, copyright: copyright, genres: genres, top100AlbumsViewModel: top100AlbumsViewModel)

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

