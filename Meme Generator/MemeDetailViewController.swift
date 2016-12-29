//
//  MemeDetailViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 12/29/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme? = nil
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        memeDetailImageView.image = meme?.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let image = memeDetailImageView.image
        
        let nextController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        nextController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}
