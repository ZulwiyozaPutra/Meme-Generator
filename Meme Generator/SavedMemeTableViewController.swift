//
//  SavedMemeTableViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 12/28/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var memes: [Meme]!
    
    func noDataLabelSetup(dataIsAvailable: Bool) -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        let label = UILabel(frame: frame)
        
        if dataIsAvailable == false {
            label.text = "Tap + to create a new meme"
            label.backgroundColor = UIColor.lightGray
            
        } else {
            label.text = ""
            label.backgroundColor = UIColor.white
        }
        label.textColor        = UIColor.darkGray
        label.textAlignment    = .center
        
        return label
    }
    
    @IBAction func addMeme(_ sender: Any) {
        
        // Create instance of UIAlertController with title and message
        let importController = UIAlertController()
        
        // Setup import from Photo Library Action
        let importFromPhotoLibraryAction = UIAlertAction(title: "Import from Photo Library", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromMediaLibrary()
        }
        
        // Setup import from camera action
        let importFromCameraAction = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromCamera()
        }
        
        importFromCameraAction.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Setup cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in
            importController.dismiss(animated: true, completion: nil)
        }
        
        // Tells importButton to add actions
        importController.addAction(importFromPhotoLibraryAction)
        importController.addAction(importFromCameraAction)
        importController.addAction(cancelAction)

        
        // Tells importButton to present importController when it is tapped
        self.present(importController, animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if memes?.count == 0 {
            
            tableView.backgroundView = noDataLabelSetup(dataIsAvailable: false)
            tableView.separatorStyle = .none
            
        } else {
            
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = noDataLabelSetup(dataIsAvailable: true)
            
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
        cell?.detailTextLabel?.text = meme.bottomCaption
        cell?.imageView?.image = meme.originalImage
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailMemeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailMemeViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailMemeViewController, animated: true)
        
    }
    
    
    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeEditorViewController = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        let navigationController = UINavigationController(rootViewController: memeEditorViewController)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memeImageToEdit = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //HELPERS//
    
    //Setup UIImagePickerController
    func setupImagePickerController(sourceType: UIImagePickerControllerSourceType) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Picking an image action from Media Library
    func pickAnImageFromMediaLibrary() {
        setupImagePickerController(sourceType: .photoLibrary)
    }
    
    //Picking an image action from Camera
    func pickAnImageFromCamera() {
        setupImagePickerController(sourceType: .camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        print("\(memes.count) of memes is available")
        tableView.reloadData()
    }
    
}
