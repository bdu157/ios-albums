//
//  AlbumController.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class AlbumController {
    
    var album: Album?
    
    func testDecodingExampleAlbum(completion: @escaping (Error?)-> Void) {
        
        var url: URL? {
            guard let filePath = Bundle.main.path(forResource: "exampleAlbum", ofType: "json") else {return nil}
            return URL(fileURLWithPath: filePath)
        }
        
        guard let jsonURL = url else {return}
        
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            //let output = try decoder.decode(Song.self, from: data)
            let output2 = try decoder.decode(Album.self, from: data)
            self.album = output2
            //print(output)
            print(output2)
            completion(nil)
        } catch {
            print("error: \(error) in decoding")
            completion(error)
        }
    }
    
    func testEncodingExampleAlbum(completion: @escaping (Error?) -> Void) {
        guard let album = album else {return}
        
        let jsonEncoder = JSONEncoder()
        
        do {
            jsonEncoder.outputFormatting = [.prettyPrinted]
            let jsonData = try jsonEncoder.encode(album)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
            completion(nil)
        } catch {
            NSLog("Error in decoding : \(error)")
            completion(error)
            return
        }
    }
}
