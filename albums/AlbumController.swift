//
//  AlbumController.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class AlbumController {
    
    func testDecodingExampleAlbum(completion: @escaping (Error?)-> Void) {
        
        var url: URL? {
            guard let filePath = Bundle.main.path(forResource: "exampleAlbum", ofType: "json") else {return nil}
            return URL(fileURLWithPath: filePath)
        }
        
        guard let jsonURL = url else {return}
        
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let output = try decoder.decode(Song.self, from: data)
            let output2 = try decoder.decode(Album.self, from: data)
            print(output)
            print(output2)
            completion(nil)
        } catch {
            print("error: \(error) in decoding")
            completion(error)
        }
    }
}
