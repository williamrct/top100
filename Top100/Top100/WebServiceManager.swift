//
//  WebServiceManager.swift
//  Top100
//
//  Created by William Rodriguez on 7/12/22.
//
//

import Foundation
import Combine



class WebServiceManager: NSObject  {
    
    static let shared = WebServiceManager()
    private var webServicesManager: WebServiceManager?
    
    private override init() {
        super.init()
    }
    
    
    func makeTop100AlbumsRSSURL() -> URL? {
        guard let url = URLComponents(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json")?.url else { return nil }
        return url
    }
    
    func getTop100AlbumsRSSFeed<T: Codable>(for url: URL, decodableType: T.Type, session: URLSession) -> AnyPublisher<T, WebServiceError> {
        
        session.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse else { throw APIError.unknown }
                switch httpResponse.statusCode {
                case 401: throw APIError.apiError(reason: "Unauthorized")
                case 403: throw APIError.apiError(reason: "Resource forbidden")
                case 404: throw APIError.apiError(reason: "Resource not found")
                case 405..<500: throw APIError.apiError(reason: "Client error")
                case 501..<600: throw APIError.apiError(reason: "Server error")
                default: break
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            //.print("WebServiceManager.queryForXMLDetailRss")
            .mapError({ error in
                //debugPrint(error.localizedDescription)
                switch error {
                case let error as DecodingError:
                    return .parserError(from: error)
                case let error as URLError:
                    return .networkError(from: error)
                case let error as APIError:
                    return .apiError(from: error)
                default:
                    return .unknown
                }
            })
            .eraseToAnyPublisher()
    }
        
}
