//
//  MemeEditorViewController.swift
//  Meme Generator
//
//  Created by Zulwiyoza Putra on 11/23/16.
//  Copyright © 2016 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickedView: UIImageView!
    @IBOutlet weak var topCaptionTextField: UITextField!
    @IBOutlet weak var bottomCaptionTextField: UITextField!
    @IBOutlet weak var helpingInformationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(initialStatus: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setup view
    func setupView(initialStatus: Bool) -> Void {
        topCaptionTextField.isHidden = initialStatus
        bottomCaptionTextField.isHidden = initialStatus
        helpingInformationLabel.isHidden = !initialStatus
        
    }
    
    //Tells delegate to clear text field when editing di begin
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.topCaptionTextField.text = ""
    }
    
    //Tells delegate to dismiss keyboard when return is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imagePickedView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
        setupView(initialStatus: false)
        
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
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

    
    @IBAction func importButton(_ sender: Any) {
        
        //Create instance of UIAlertController with title and message
        let importController = UIAlertController()
        importController.title = "Import image"
        importController.message = "Pick your best image to generate meme"
        
        //Setup import from Photo Library Action
        let importFromPhotoLibrary = UIAlertAction(title: "Import from Photo Library", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
            self.pickAnImageFromMediaLibrary()
        }
        
        //Setup import from camera action
        let importFromCamera = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
            self.pickAnImageFromCamera()
        }
        
        //Tells importButton to add actions
        importController.addAction(importFromPhotoLibrary)
        importController.addAction(importFromCamera)
        
        //Tells importButton to present importController when it is tapped
        self.present(importController, animated: true, completion: nil)
        
    }
    
}
