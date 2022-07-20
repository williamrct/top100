//
//  Top100AlbumModel.swift
//  Top100
//
//  Created by William Rodriguez on 7/12/22.
//
//

import Foundation
import Combine
import RealmSwift

//MARK: - Top100AlbumsViewModel
final class Top100AlbumsViewModel: ObservableObject {
    
    enum State {
        case isWaiting
        case isLoading
        case didFail(Error)
        case didLoad
        case networkUnavailable
    }

    @Published var state: State = .isWaiting {
        willSet {
            objectWillChange.send()
        }
    }
 
    @Published var top100AlbumsFeed: Feed? {
        willSet {
            objectWillChange.send()
        }
    }
    
    private var networkAvailable: Bool = false
    
    private let realm: Realm
    
    // WebServices Singleton
    var webServiceManager =  WebServiceManager.shared
    var sessionConfiguration: URLSessionConfiguration
    
    private var top100AlbumsRSSFeedURL: URL? { webServiceManager.makeTop100AlbumsRSSURL() }
    
    var rssSubscription: AnyCancellable?
    var rssSubject = PassthroughSubject<Void, WebServiceError>()
    
    var top100AlbumsRSSFeedSession: URLSession
    
    init(realmConfiguration: Realm.Configuration) {
        self.realm = try! Realm(configuration: realmConfiguration)
        self.sessionConfiguration = URLSessionConfiguration.default
        self.sessionConfiguration.timeoutIntervalForRequest = 30
        self.top100AlbumsRSSFeedSession = URLSession(configuration: self.sessionConfiguration)
        self.state = .isWaiting
        
        self.checkInternetAvailabilityIfChangedPreviousValue(self.networkAvailable)
        
        self.top100AlbumsRSSFeedSubscription()
        
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
    }
    
    func top100AlbumsRSSFeedSubscription() {
        
        guard let url = self.top100AlbumsRSSFeedURL else { return }
        
        rssSubscription = rssSubject
            .flatMap { _ in self.webServiceManager.getTop100AlbumsRSSFeed(for: url, decodableType: Top100AlbumsFeedResponse.self, session: self.top100AlbumsRSSFeedSession).receive(on: DispatchQueue.main)}
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    //debugPrint("error setRssSubscription \(error)")
                    self.state = .didFail(error)
                case .finished:
                    //debugPrint("finished setRssSubscription")
                    break
                }
            }) { top100AlbumsFeedResponse in
                debugPrint("top100AlbumsFeedResponse.feed \(top100AlbumsFeedResponse.feed)")
                self.state = .didLoad
                self.top100AlbumsFeed = top100AlbumsFeedResponse.feed
                self.persistFeed(feed: top100AlbumsFeedResponse.feed)
            }
    }
    
    func persistFeed(feed: Feed) {
        
        try? self.realm.write {
            if !self.realm.isEmpty {
                self.realm.deleteAll()
            }
            let persistedFeed = PersistedFeed()
            persistedFeed.title = feed.title
            persistedFeed.feedId = feed.id
            persistedFeed.author = feed.author.name
            persistedFeed.authorUrl = feed.author.url
            persistedFeed.icon = feed.icon
            
            for link in feed.links {
                let newLink = PersistedLink()
                newLink.link = link.linkSelf
                persistedFeed.links.append(newLink)
            }
            
            persistedFeed.copyright = feed.copyright
            persistedFeed.country = feed.country
            persistedFeed.icon = feed.icon
            persistedFeed.updated = feed.updated
            persistedFeed.icon = feed.icon
            
            for result in feed.results {
                let persistedResult = PersistedResult()
                persistedResult.artistName = result.artistName
                persistedResult.albumId = result.id
                persistedResult.artistName = result.artistName
                persistedResult.name = result.name
                persistedResult.releaseDate = result.releaseDate
                persistedResult.kind = result.kind
                persistedResult.artistId = result.artistId ?? ""
                persistedResult.artistUrl = result.artistUrl ?? ""
                persistedResult.contentAdvisoryRating = result.contentAdvisoryRating ?? ""
                persistedResult.artworkUrl100 = result.artworkUrl100
                persistedResult.artistName = result.artistName
                
                for genre in result.genres {
                    let persistedGenre = PersistedGenre()
                    persistedGenre.genreId = genre.genreId
                    persistedGenre.name = genre.name
                    persistedGenre.url = genre.url
                    persistedResult.genres.append(persistedGenre)
                }
                
                persistedResult.url = result.url
                persistedFeed.results.append(persistedResult)
            }
            
            self.realm.add(persistedFeed)
        }
        
    }

    func load() {
        if self.networkAvailable {
            self.state = .isLoading
            rssSubject.send()
        } else {
            self.state = .networkUnavailable
            self.top100AlbumsFeed = self.loadPersistedFeed()
        }
    }
    
    func loadPersistedFeed() -> Feed? {
        let fetchedFeeds: Results<PersistedFeed> = realm.objects(PersistedFeed.self)
        if fetchedFeeds.isEmpty {
            return nil
        } else {
            guard let fetchedFeed = fetchedFeeds.first else { return nil }
            let author = Author(name: fetchedFeed.author, url: fetchedFeed.authorUrl)
            
            var links = [Link]()
            
            for fetchedLink in fetchedFeed.links {
                let selfLink = Link(linkSelf: fetchedLink.link)
                links.append(selfLink)
            }
            
            var results = [Result]()
            
            for fetchedResult in fetchedFeed.results {
                var genres = [Genre]()
                for fetchedGenre in fetchedResult.genres {
                    let genre = Genre(genreId: fetchedGenre.genreId , name: fetchedGenre.name , url: fetchedGenre.url )
                    genres.append(genre)
                }
                let result = Result(artistName: fetchedResult.artistName , id: fetchedResult.albumId , name: fetchedResult.name , releaseDate: fetchedResult.releaseDate , kind: fetchedResult.kind , artistId: fetchedResult.artistId , artistUrl: fetchedResult.artistUrl , contentAdvisoryRating: fetchedResult.contentAdvisoryRating , artworkUrl100: fetchedResult.artworkUrl100 , genres: genres, url: fetchedResult.url )
                results.append(result)
            }
            
            let feed = Feed(title: fetchedFeed.title, id: fetchedFeed.feedId, author: author, links: links, copyright: fetchedFeed.copyright, country: fetchedFeed.country, icon: fetchedFeed.icon, updated: fetchedFeed.updated, results: results)
            
            return feed
            
        }
    }
    
    func cancelSubscriptions() {
        rssSubscription?.cancel()
    }
    
    func checkInternetAvailabilityIfChangedPreviousValue(_ previousValue: Bool) {
        let currentValue = NetworkConnectionManager.isConnectedToNetwork()
        if !previousValue && currentValue {
            self.networkAvailable = true
        } else if previousValue && !currentValue {
            self.networkAvailable = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.checkInternetAvailabilityIfChangedPreviousValue(self.networkAvailable)
        }
    }
    
    final func loadImage(imageURL: NSURL, completion: @escaping (UIImage?) -> Swift.Void) {
        if let cachedImage = getCachedImage(imageURL: imageURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        DispatchQueue.global().async { [weak self] in
           
            guard let self = self else { return }
           
            guard let url = URL(string: imageURL.absoluteString ?? "") else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: imageData) else { return }
                self.cacheImage(imageURL: imageURL, imageData: imageData)
                completion(image)
            }
            return
        }
    }
    
    func cacheImage(imageURL: NSURL, imageData: Data) {
        guard let urlString = imageURL.absoluteString else { return }
        let cachedImage = CachedImage()
        cachedImage.url = urlString
        cachedImage.imageData = imageData
        try? realm.write {
            realm.add(cachedImage)
        }
    }
    
    func getCachedImage(imageURL: NSURL) -> UIImage? {
        guard let urlString = imageURL.absoluteString else { return nil }
        let cachedImages = realm.objects(CachedImage.self).filter("url = '\(urlString)'")
        guard let cachedImage = cachedImages.first else { return nil }
        guard let image = UIImage(data: cachedImage.imageData ) else { return nil }
        return image
    }
}



