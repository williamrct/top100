//
//  ImageLoader.swift
//  Top100
//
//  Created by William Rodriguez on 7/12/22.
//
//

import UIKit
import Foundation
import Combine
import RealmSwift

class CachedImageObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var image = Data()
}


public class ImageLoader {
    
    public static let shared = ImageLoader()
    
    var placeholderImage = UIImage(named: "placeholderimage")
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }

    final func loadImage(imageURL: NSURL, completion: @escaping (UIImage?) -> Swift.Void) {
        if let cachedImage = image(url: imageURL) {
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
                self.cachedImages.setObject(image, forKey: imageURL, cost: imageData.count)
                completion(image)
            }
            return
        }
    }
        
}
