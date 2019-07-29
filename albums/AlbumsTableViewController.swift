//
//  AlbumsTableViewController.swift
//  albums
//
//  Created by Dongwoo Pae on 7/24/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import Foundation

class AlbumsTableViewController: UITableViewController {

    var albumController = AlbumController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albumController.getAlbums { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.albumController.album.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        let album = self.albumController.album[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artist
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAlbumDetailVCFromAdd" {
            guard let destVC = segue.destination as? AlbumDetailTableViewController else {return}
            destVC.albumController = self.albumController
        } else if segue.identifier == "ToAlbumDetailVCFromCell" {
            guard let destVC = segue.destination as? AlbumDetailTableViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow else {return}
            destVC.albumController = self.albumController
            destVC.album = self.albumController.album[selectedRow.row]
        }
    }

}
