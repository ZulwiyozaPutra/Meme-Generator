//
//  ViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 11/13/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func importImage(_ sender: Any) {
        let nextController = UIImagePickerController()
        self.present(nextController, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let image = UIImage()
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(nextController, animated: true, completion: nil)
    }
    
    @IBAction func other(_ sender: Any) {
        let nextController = UIAlertController()
        nextController.title = "Title test alert"
        nextController.message = "Message test alert"
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        nextController.addAction(okAction)
        
        self.present(nextController, animated: true, completion: nil)
    }
    

}

