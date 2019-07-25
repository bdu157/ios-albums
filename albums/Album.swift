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
        
        //songs????
        //var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        var songsArray: [Song] = []
        while songsContainer.isAtEnd == false {
            let song = try container.decode(Song.self, forKey: .songs)
            songsArray.append(song)
        }
        self.songs = songsArray
    }
}

struct Song: Decodable {    //song needs to be treated as one and when you use songs within album above you create an array of songs that were fetched below

    enum SongKey: String, CodingKey {
        case songs
        
        enum SongDescriptionKey: String, CodingKey {
            case duration
            case id
            case name
            
            enum durationKey: String, CodingKey {
                case duration
            }
            
            enum nameKey: String, CodingKey {
                case title
            }
        }
    }
    
    var songDuration:String
    var songName: String
    var id: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKey.self)
        //array of songs
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        let songDescriptionContainer = try songsContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.self)
        //songDuration
        let durationContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.durationKey.self, forKey: .duration)
        let duration = try durationContainer.decode(String.self, forKey: .duration)
        self.songDuration = duration
        //songName
        let nameContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.nameKey.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        self.songName = title
        //id
        self.id = try songDescriptionContainer.decode(String.self, forKey: .id)
        /*
        //songDurations
        var durations: [String] = []
        while songsContainer.isAtEnd == false {
            let songDescriptionContainer = try songsContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.self)
            let durationContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.durationKey.self, forKey: .duration)
            let duration = try durationContainer.decode(String.self, forKey: .duration)
            durations.append(duration)
        }
        self.songDuration = durations
        
        //songNames
        var names: [String] = []
        while songsContainer.isAtEnd == false {
            let songDescriptionContainer = try songsContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.self)
            let nameContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.nameKey.self, forKey: .name)
            let name = try nameContainer.decode(String.self, forKey: .title)
            names.append(name)
        }
        self.songName = names
        */
        
    }
}
