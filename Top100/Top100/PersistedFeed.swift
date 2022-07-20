//
//  PersistedFeed.swift
//  Top100
//
//  Created by William Rodriguez on 7/19/22.
//

import Foundation
import Combine
import RealmSwift

class PersistedFeed: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var feedId = ""
    @Persisted var author = ""
    @Persisted var authorUrl = ""
    @Persisted var links = List<PersistedLink>()
    @Persisted var copyright = ""
    @Persisted var country = ""
    @Persisted var icon = ""
    @Persisted var updated = ""
    @Persisted var results = List<PersistedResult>()
}

class PersistedLink: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var link = ""
}

class PersistedResult: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var artistName = ""
    @Persisted var albumId = ""
    @Persisted var name = ""
    @Persisted var releaseDate = ""
    @Persisted var kind = ""
    @Persisted var artistId = ""
    @Persisted var artistUrl = ""
    @Persisted var contentAdvisoryRating = ""
    @Persisted var artworkUrl100 = ""
    @Persisted var genres = List<PersistedGenre>()
    @Persisted var url = ""
}

class PersistedGenre: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var genreId = ""
    @Persisted var name = ""
    @Persisted var url = ""
}


