//
//  AlbumController.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class AlbumController {
    
    var album: [Album] = []

    
    var baseURL = URL(string: "https://task-coredata.firebaseio.com/")!
    
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
            self.album.append(output2)
            //print(output)
            print(output2)
            completion(nil)
        } catch {
            print("error: \(error) in decoding")
            completion(error)
        }
    }
    
    func testEncodingExampleAlbum(completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent(album[0].id).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        
        do {
            //jsonEncoder.outputFormatting = [.prettyPrinted]
            let jsonData = try jsonEncoder.encode(album.first)
            request.httpBody = jsonData
            //let jsonString = String(data: jsonData, encoding: .utf8)
            //print(jsonString!)
            //completion(nil)
        } catch {
            NSLog("Error in decoding : \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("there is an error in putting : \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    //fetch album - there is an initial album being available to be fetched from firebase
    func getAlbums(completion:@escaping (Error?)->Void) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("there is an error in fetching data : \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("There is an error in getting the data")
                completion(error)
                return
            }
            
            do {
                let albumData  = try JSONDecoder().decode([String: Album].self, from: data)
                self.album = albumData.map {$0.value}
                completion(nil)
            } catch {
                NSLog("there is an error in decoding data from firebase")
                completion(error)
                return
            }
        }.resume()
    }
    
    func put(album:Album, completion: @escaping (Error?)->Void) {
        let requestURL = baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(album)
            request.httpBody = jsonData
        } catch {
            NSLog("There is an error in encoding : \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("there is an error in PUTing: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func createAlbum(name: String, artist: String, genres: [String], coverArt: [String], songs: [Song]) {
        let createdAlbum = Album(name: name, artist: artist, genres: genres, coverArt: coverArt, songs: songs)
        self.album.append(createdAlbum)
        if createdAlbum.songs != [] {
            put(album: createdAlbum) { (error) in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
    
    func createSong(name: String, duration: String) -> Song {
        let createdSong = Song(duration: duration, name: name)
        return createdSong
    }
    
    func update(for album: Album, nameTo name: String, artistTo artist: String, genresTo genres: [String], coverArtTo coverArt: [String], songsTo songs: [Song]) {
        guard let location = self.album.firstIndex(of: album) else {return}
        //var updatingAlbum = self.album[index]
            self.album[location].name = name
            self.album[location].artist = artist
            self.album[location].genres = genres
            self.album[location].coverArt = coverArt
            self.album[location].songs = songs
    
        
        if album.songs != [] {
            self.put(album: album) { (error) in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
}
