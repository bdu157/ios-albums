//
//  Album.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//
import Foundation
struct Album: Decodable {
    
    enum AlbumKey: String, CodingKey {
        case name
        case artist
        case genres
        case coverArt
        case id
        case songs
    
        enum CoverArtKey: String, CodingKey {
            case url
        }
    }
    var name: String
    var artist: String
    var genres: String
    var coverArt: String
    var id: String
    var songs: [Song]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKey.self)
        //name
        self.name = try container.decode(String.self, forKey: .name)
        //artist
        self.artist = try container.decode(String.self, forKey: .artist)
        //genres
        var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        self.genres = try genresContainer.decode(String.self)
        //coverArt
        var coverArtDescription = try container.nestedUnkeyedContainer(forKey: .coverArt)
        let coverArtContainer = try coverArtDescription.nestedContainer(keyedBy: AlbumKey.CoverArtKey.self)
        self.coverArt = try coverArtContainer.decode(String.self, forKey: .url)
        //id
        self.id = try container.decode(String.self, forKey: .id)
        //songs
        self.songs = try container.decode([Song].self, forKey: .songs)   //(?) - why would this work as well?
//        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
//        var songss: [Song] = []
//        while songsContainer.isAtEnd == false {
//            let oneSong = try songsContainer.decode(Song.self)
//            songss.append(oneSong)
//        }
//        self.songs = songss
        }
}

struct Song: Decodable {    //song needs to be treated as one and when you use songs within album above you create an array of songs that were decoded below
    enum SongKey: String, CodingKey {
        case songDuration = "duration"
        case songName = "name"
        case id
        
            enum durationKey: String, CodingKey {
                case duration
            }
            
            enum nameKey: String, CodingKey {
                case title
            }
    }
    var songDuration: String
    var songName: String
    var id: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKey.self)
        //songDuration
        let songDurationContainer = try container.nestedContainer(keyedBy: SongKey.durationKey.self, forKey: .songDuration)
        let duration = try songDurationContainer.decode(String.self, forKey: .duration)
        self.songDuration = duration
        //songName
        let songNameContainer = try container.nestedContainer(keyedBy: SongKey.nameKey.self, forKey: .songName)
        let title = try songNameContainer.decode(String.self, forKey: .title)
        self.songName = title
        //id
        self.id = try container.decode(String.self, forKey: .id)
    }
}
