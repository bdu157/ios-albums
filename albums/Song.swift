//
//  Song.swift
//  albums
//
//  Created by Dongwoo Pae on 7/25/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Song: Codable {    //song needs to be treated as one and when you use songs within album above you create an array of songs that were decoded below
    enum SongKey: String, CodingKey {
        case duration
        case name
        case id
        
        enum durationKey: String, CodingKey {
            case duration
        }
        
        enum nameKey: String, CodingKey {
            case title
        }
    }
    var duration: String
    var name: String
    var id: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKey.self)
        //songDuration
        let songDurationContainer = try container.nestedContainer(keyedBy: SongKey.durationKey.self, forKey: .duration)
        let duration = try songDurationContainer.decode(String.self, forKey: .duration)
        self.duration = duration
        //songName
        let songNameContainer = try container.nestedContainer(keyedBy: SongKey.nameKey.self, forKey: .name)
        let title = try songNameContainer.decode(String.self, forKey: .title)
        self.name = title
        //id
        self.id = try container.decode(String.self, forKey: .id)
    }
    
    func encode(with encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SongKey.self)
        //songDuration
        
        var songContainer1 =  container.nestedContainer(keyedBy: SongKey.durationKey.self, forKey: .duration)
        var songDurationContainer = songContainer1.nestedContainer(keyedBy: SongKey.durationKey.self, forKey: .duration)
        try songDurationContainer.encode(self.duration, forKey: .duration)
        //songName
        
        var songContainer2 = container.nestedContainer(keyedBy: SongKey.nameKey.self, forKey: .name)
        var songNameContainer = songContainer2.nestedContainer(keyedBy: SongKey.nameKey.self, forKey: .title)
        try songNameContainer.encode(self.name, forKey: .title)
        
        //id
        try container.encode(self.id, forKey: .id)
        
    }
}
