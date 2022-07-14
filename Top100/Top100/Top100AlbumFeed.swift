//
//  Top100AlbumFeed.swift
//  Top100
//
//  Created by William Rodriguez on 7/12/22.
//
//

import Foundation

struct Top100AlbumsFeedResponse: Codable  {
    let feed: Feed
}

struct Feed: Codable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright, country: String
    let icon: String
    let updated: String
    let results: [Result]
}

struct Author: Codable  {
    let name: String
    let url: String
}

struct Link: Codable  {
    let linkSelf: String
    
    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
    }
}

struct Result: Codable  {
    let artistName, id, name, releaseDate: String
    let kind: String
    let artistId: String?
    let artistUrl: String?
    let contentAdvisoryRating: String?
    let artworkUrl100: String
    let genres: [Genre]
    let url: String

}

struct Genre: Codable  {
    let genreId, name: String
    let url: String
}


/*
 {
   "feed": {
     "title": "Top Albums",
     "id": "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json",
     "author": {
       "name": "Apple",
       "url": "https://www.apple.com/"
     },
     "links": [
       {
         "self": "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
       }
     ],
     "copyright": "Copyright © 2022 Apple Inc. All rights reserved.",
     "country": "us",
     "icon": "https://www.apple.com/favicon.ico",
     "updated": "Tue, 12 Jul 2022 12:49:41 +0000",
     "results": [
       {
         "artistName": "Brent Faiyaz",
         "id": "1629943089",
         "name": "WASTELAND",
         "releaseDate": "2022-07-08",
         "kind": "albums",
         "artistId": "960127446",
         "artistUrl": "https://music.apple.com/us/artist/brent-faiyaz/960127446",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/1a/b6/3a/1ab63ac4-2bc3-3907-5944-52af47196a2e/193436294690_wastelandart.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "15",
             "name": "R&B/Soul",
             "url": "https://itunes.apple.com/us/genre/id15"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/wasteland/1629943089"
       },
       {
         "artistName": "Bad Bunny",
         "id": "1622045624",
         "name": "Un Verano Sin Ti",
         "releaseDate": "2022-05-06",
         "kind": "albums",
         "artistId": "1126808565",
         "artistUrl": "https://music.apple.com/us/artist/bad-bunny/1126808565",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music112/v4/3e/04/eb/3e04ebf6-370f-f59d-ec84-2c2643db92f1/196626945068.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "12",
             "name": "Latin",
             "url": "https://itunes.apple.com/us/genre/id12"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/un-verano-sin-ti/1622045624"
       },
       {
         "artistName": "Drake",
         "id": "1630230040",
         "name": "Honestly, Nevermind",
         "releaseDate": "2022-06-17",
         "kind": "albums",
         "artistId": "271256",
         "artistUrl": "https://music.apple.com/us/artist/drake/271256",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is4-ssl.mzstatic.com/image/thumb/Music122/v4/84/2c/b4/842cb419-243c-b3f4-4da9-b6b980996062/22UMGIM67371.rgb.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "17",
             "name": "Dance",
             "url": "https://itunes.apple.com/us/genre/id17"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/honestly-nevermind/1630230040"
       },
       {
         "artistName": "Chris Brown",
         "id": "1633160273",
         "name": "Breezy (Deluxe)",
         "releaseDate": "2022-06-24",
         "kind": "albums",
         "artistId": "95705522",
         "artistUrl": "https://music.apple.com/us/artist/chris-brown/95705522",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/89/69/0e/89690e05-5083-9c45-8234-da634c5bed9a/196589286413.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "15",
             "name": "R&B/Soul",
             "url": "https://itunes.apple.com/us/genre/id15"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/breezy-deluxe/1633160273"
       },
       {
         "artistName": "Lil Durk",
         "id": "1631419758",
         "name": "7220 (Deluxe)",
         "releaseDate": "2022-03-11",
         "kind": "albums",
         "artistId": "541282483",
         "artistUrl": "https://music.apple.com/us/artist/lil-durk/541282483",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/53/d6/b9/53d6b9fb-8353-228d-d846-f13171d94a2d/196589267719.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "18",
             "name": "Hip-Hop/Rap",
             "url": "https://itunes.apple.com/us/genre/id18"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/7220-deluxe/1631419758"
       },
       {
         "artistName": "Burna Boy",
         "id": "1623677591",
         "name": "Love, Damini",
         "releaseDate": "2022-07-07",
         "kind": "albums",
         "artistId": "591899010",
         "artistUrl": "https://music.apple.com/us/artist/burna-boy/591899010",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/34/42/db/3442dbd6-644f-a111-8344-0151ffb93313/075679745156.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "19",
             "name": "Worldwide",
             "url": "https://itunes.apple.com/us/genre/id19"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/love-damini/1623677591"
       },
       {
         "artistName": "Future",
         "id": "1621803882",
         "name": "I NEVER LIKED YOU",
         "releaseDate": "2022-04-29",
         "kind": "albums",
         "artistId": "128050210",
         "artistUrl": "https://music.apple.com/us/artist/future/128050210",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/c1/27/d1/c127d12a-d259-dbd9-7d02-75056e376fb6/196589131805.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "18",
             "name": "Hip-Hop/Rap",
             "url": "https://itunes.apple.com/us/genre/id18"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/i-never-liked-you/1621803882"
       },
       {
         "artistName": "GIVĒON",
         "id": "1627365840",
         "name": "Give Or Take",
         "releaseDate": "2022-06-24",
         "kind": "albums",
         "artistId": "1070668868",
         "artistUrl": "https://music.apple.com/us/artist/giv%C4%93on/1070668868",
         "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/04/51/dc/0451dce5-5809-a4ac-e015-52f9490f8034/886449310944.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "15",
             "name": "R&B/Soul",
             "url": "https://itunes.apple.com/us/genre/id15"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/give-or-take/1627365840"
       },
       {
         "artistName": "Harry Styles",
         "id": "1615584999",
         "name": "Harry's House",
         "releaseDate": "2022-05-20",
         "kind": "albums",
         "artistId": "471260289",
         "artistUrl": "https://music.apple.com/us/artist/harry-styles/471260289",
         "artworkUrl100": "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/2a/19/fb/2a19fb85-2f70-9e44-f2a9-82abe679b88e/886449990061.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "14",
             "name": "Pop",
             "url": "https://itunes.apple.com/us/genre/id14"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/harrys-house/1615584999"
       },
       {
         "artistName": "Kendrick Lamar",
         "id": "1626195790",
         "name": "Mr. Morale & The Big Steppers",
         "releaseDate": "2022-05-13",
         "kind": "albums",
         "artistId": "368183298",
         "artistUrl": "https://music.apple.com/us/artist/kendrick-lamar/368183298",
         "contentAdvisoryRating": "Explict",
         "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/f6/65/b5/f665b52b-8d6d-b94d-cc2c-db826e35304e/22UMGIM52376.rgb.jpg/100x100bb.jpg",
         "genres": [
           {
             "genreId": "18",
             "name": "Hip-Hop/Rap",
             "url": "https://itunes.apple.com/us/genre/id18"
           },
           {
             "genreId": "34",
             "name": "Music",
             "url": "https://itunes.apple.com/us/genre/id34"
           }
         ],
         "url": "https://music.apple.com/us/album/mr-morale-the-big-steppers/1626195790"
       }
     ]
   }
 }
*/
