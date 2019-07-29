//
//  Album.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//
import Foundation

struct Album: Codable, Equatable {

    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return (lhs.name == rhs.name &&
            lhs.artist == rhs.artist &&
            lhs.genres == rhs.genres &&
            lhs.id == rhs.id &&
            lhs.songs == rhs.songs)
    }
    
    
    static func != (lhs: Album, rhs: Album) -> Bool {
        return !(rhs == lhs)
    }

    
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

    init(name: String, artist: String, genres: [String], coverArt:[String], id: String = UUID().uuidString, songs: [Song] = []) {
        self.name = name
        self.artist = artist
        self.genres = genres
        self.coverArt = coverArt
        self.id = id
        self.songs = songs
    }
    
    var name: String
    var artist: String
    var genres: [String]
    var coverArt: [String]
    var id: String
    var songs: [Song]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKey.self)
        //name
        self.name = try container.decode(String.self, forKey: .name)
        //artist
        self.artist = try container.decode(String.self, forKey: .artist)
        //genres
        //var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        self.genres = try container.decode([String].self, forKey: .genres)
        //coverArt
        var coverArtArrayContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        let coverArtContainer = try coverArtArrayContainer.nestedContainer(keyedBy: AlbumKey.CoverArtKey.self)
        let coverArt = try coverArtContainer.decode(String.self, forKey: .url)
        self.coverArt = [coverArt]
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlbumKey.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.artist, forKey: .artist)
        try container.encode(self.genres, forKey: .genres)
        //coverArt
        var coverArtArrayContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        var coverArtContainer = coverArtArrayContainer.nestedContainer(keyedBy: AlbumKey.CoverArtKey.self)
        for coverArt in self.coverArt {
            try coverArtContainer.encode(coverArt, forKey: .url)
        }
        
        //id
        try container.encode(self.id, forKey: .id)
        
        //songs
        try container.encode(self.songs, forKey: .songs)
        
    }
}
