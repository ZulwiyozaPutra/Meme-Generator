//
//  SavedMemeTableViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 12/28/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeTableViewController: UITableViewController {
    
    var memes: [Meme]!

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")
        let meme = memes[indexPath.row]
        cell?.textLabel?.text = meme.topCaption
        cell?.imageView?.image = meme.originalImage
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailMemeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailMemeViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailMemeViewController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
}
