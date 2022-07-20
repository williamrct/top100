//
//  CachedImage.swift
//  Top100
//
//  Created by William Rodriguez on 7/19/22.
//

import Foundation
import Combine
import RealmSwift

class CachedImage: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var url = ""
    @Persisted var imageData = Data()

}

/*struct CachedImage: Identifiable {
 var id: String
 var url: String
 var imageData: Data

 init(url: String, imageData: Data)  {
     self.id = url
     self.url = url
     self.imageData = imageData
 }
}*/

