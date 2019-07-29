//
//  AlbumDetailTableViewController.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    

    var albumController: AlbumController?

    var album: Album? {
        didSet {
            self.updateViews()
        }
    }
    
    var tempSongs: [Song] = []
    //MARK : Outlets
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var GenresTextField: UITextField!
    @IBOutlet weak var URLsTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempSongs.count
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 0
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let customCell = cell as? SongTableViewCell else {return UITableViewCell()}
        customCell.delegate = self
        customCell.song = tempSongs[indexPath.row]
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let albumController = albumController,
             let name = albumNameTextField.text,
            let artist = artistTextField.text,
           let geners = GenresTextField.text,
          let coverArt = URLsTextField.text else {return}
        if let passedAlbum = album {
            albumController.update(for: passedAlbum, nameTo: name, artistTo: artist, genresTo: [geners], coverArtTo: [coverArt], songsTo: tempSongs)
        } else {
            albumController.createAlbum(name: name, artist: artist, genres: [geners], coverArt: [coverArt], songs: tempSongs)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        if let album = album, isViewLoaded {
            self.albumNameTextField.text = album.name
            self.artistTextField.text = album.artist
            self.GenresTextField.text = album.genres.joined(separator: ",")
            self.URLsTextField.text = album.coverArt.joined(separator: ",")
            self.tempSongs = album.songs
            self.title = album.name
        } else {
            self.title = "Create a New Album"
        }
    }
    
    func addSong(with title: String, duration: String) {
        let song = self.albumController?.createSong(name: title, duration: duration)
        guard let songInput = song else {return}
        self.tempSongs.append(songInput)
        self.tableView.reloadData()
        //self.tableView.scrollToRow(at: 0, at: <#T##UITableView.ScrollPosition#>, animated: <#T##Bool#>)
    }
}
