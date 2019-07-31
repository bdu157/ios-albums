//
//  SongTableViewCell.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import Foundation

protocol SongTableViewCellDelegate {
    func addSong(with title: String, duration: String)
}

class SongTableViewCell: UITableViewCell {
    
    var song: Song? {
        didSet {
            self.updateViews()
        }
    }
    //MARK: Outlets
    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    
 
    var delegate: SongTableViewCellDelegate?
    

    @IBAction func addSongButtonTapped(_ sender: Any) {
            guard let songName = songTitleTextField.text,
                let duration = durationTextField.text else  {return}
        self.delegate?.addSong(with: songName, duration: duration)
    }
    
    func updateViews() {
        if let song = song {
            self.songTitleTextField.text = song.name
            self.durationTextField.text = song.duration
        } else {
            
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
    }
}
/*
 prepareForReuse() -> ??
 tableView.scrollToRow(at: IndexPath, ...) -> it has to do with cell being now shown
 heightForRowAt -> so it will show songs cell
 */
