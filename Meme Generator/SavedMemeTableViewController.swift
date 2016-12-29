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
    
    func noDataLabelSetup(message: String) -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        let label = UILabel(frame: frame)
        label.text             = message
        label.textColor        = UIColor.black
        label.textAlignment    = .center
        
        return label
    }
    
    @IBAction func addMeme(_ sender: Any) {
        let memeEditor = storyboard!.instantiateViewController(withIdentifier: "MemeEditorRootViewController") as! UINavigationController
        self.present(memeEditor, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if memes?.count == 0 {
            
            tableView.backgroundView = noDataLabelSetup(message: "Tap + to create a new meme")
            tableView.separatorStyle = .none
            
        } else {
            
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = noDataLabelSetup(message: "")
            
        } 
        return numOfSections
    }

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
        print("\(memes.count) of memes is available")
        tableView.reloadData()
    }
    
}
