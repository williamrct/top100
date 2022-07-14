//
//  Top100AlbumModel.swift
//  Top100
//
//  Created by William Rodriguez on 7/12/22.
//
//

import Foundation
import Combine

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
    
    // WebServices Singleton
    var webServiceManager =  WebServiceManager.shared
    var sessionConfiguration: URLSessionConfiguration
    
    private var top100AlbumsRSSFeedURL: URL? { webServiceManager.makeTop100AlbumsRSSURL() }
    
    var rssSubscription: AnyCancellable?
    var rssSubject = PassthroughSubject<Void, WebServiceError>()
    
    var top100AlbumsRSSFeedSession: URLSession
    
    init() {
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
                    debugPrint("error setRssSubscription \(error)")
                    self.state = .didFail(error)
                case .finished:
                    debugPrint("finished setRssSubscription")
                    break
                }
            }) { top100AlbumsFeedResponse in
                debugPrint("top100AlbumsFeedResponse.feed \(top100AlbumsFeedResponse.feed)")
                self.state = .didLoad
                self.top100AlbumsFeed = top100AlbumsFeedResponse.feed
            }
    }


    func load() {
        if self.networkAvailable {
            self.state = .isLoading
            rssSubject.send()
        } else {
            self.state = .networkUnavailable
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
    
}



