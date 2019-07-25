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
    }
    
    var name: String    //Album name
    var artist: String  //Artist
    var genres: [String] //Genres
    var coverArt: [URL] //CoverArt
}







struct Song: Decodable {
    
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
    
    var songDurations: [String]
    var songNames: [String]
    //var id: String ??
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKey.self)
        
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        
        //songDurations
        var durations: [String] = []
        while songsContainer.isAtEnd == false {
            let songDescriptionContainer = try songsContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.self)
            let durationContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.durationKey.self, forKey: .duration)
            let duration = try durationContainer.decode(String.self, forKey: .duration)
            durations.append(duration)
        }
        self.songDurations = durations
        
        //songNames
        var names: [String] = []
        while songsContainer.isAtEnd == false {
            let songDescriptionContainer = try songsContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.self)
            let nameContainer = try songDescriptionContainer.nestedContainer(keyedBy: SongKey.SongDescriptionKey.nameKey.self, forKey: .name)
            let name = try nameContainer.decode(String.self, forKey: .title)
            names.append(name)
        }
        self.songNames = names
        
        //id  ??
        
    }
    
}
