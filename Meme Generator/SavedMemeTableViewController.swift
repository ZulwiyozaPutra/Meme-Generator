//
//  SavedMemeTableViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 12/28/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    memes = appDelegate.memes
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TODO: FILL THIS")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    
}
