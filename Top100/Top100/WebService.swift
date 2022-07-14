//
//  WebService.swift
//  Top100
//
//  Created by William Rodriguez on 7/11/22.
//
//

import Foundation
import Combine


//MARK: - WEBSERVICE ERROR
enum WebServiceError: Error, LocalizedError {
    case unknown
    case urlError
    case apiError(from: APIError)
    case parserError(from: DecodingError)
    case networkError(from: URLError)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .urlError:
            return "URL error"
        case .apiError(let from):
            return from.errorDescription
        case .parserError(let from):
            return from.localizedDescription
        case .networkError(let from):
            return from.localizedDescription
        }
    }
}

//MARK: - API ERROR
enum APIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown API error"
        case .apiError(let reason):
            return reason
        }
    }
}

var firstTime: Bool = true

enum API {
    
    static func decode<T>(_ t: T.Type, _ jsonData: Data) -> T? where T: Codable {
        do {
            let decodedObject = try JSONDecoder().decode(t, from: jsonData)
            return decodedObject
        } catch {
            //debugPrint("DECODING ERROR!!!\n")
            return nil
        }
    }

}
