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
    
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var equalWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var equalHeightConstraint: NSLayoutConstraint!
    

    
    let memeTextAttributes:[String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSStrokeWidthAttributeName: -4.0]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topCaptionTextField.delegate = self
        self.bottomCaptionTextField.delegate = self
        
        viewSetup(initialStatus: true)
        textFieldTextAttributesSetup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        func landscapeMode() {
            view.removeConstraint(equalWidthConstraint)
            view.addConstraint(equalHeightConstraint)
        }
        
        func potraitMode() {
            view.removeConstraint(equalHeightConstraint)
            view.addConstraint(equalWidthConstraint)
        }

        if UIDevice.current.orientation.isLandscape {
            landscapeMode()
            
        } else if UIDevice.current.orientation.isPortrait {
            potraitMode()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return newText.length <= 18
    }
    
    //Setup Text Field Text Attributes
    func textFieldTextAttributesSetup() {
        topCaptionTextField.defaultTextAttributes = memeTextAttributes
        topCaptionTextField.textAlignment = .center
        bottomCaptionTextField.defaultTextAttributes = memeTextAttributes
        bottomCaptionTextField.textAlignment = .center
    }
    
    //Setup view
    func viewSetup(initialStatus: Bool) -> Void {
        topCaptionTextField.isHidden = initialStatus
        bottomCaptionTextField.isHidden = initialStatus
        helpingInformationLabel.isHidden = !initialStatus
        shareButtonOutlet.isEnabled = !initialStatus
        
    }
    
    //Tells delegate to clear text field when editing di begin
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    //Tells delegate to dismiss keyboard when return is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if topCaptionTextField.text == "" {
            topCaptionTextField.text = "TOP CAPTION"
        }
        if bottomCaptionTextField.text == "" {
            bottomCaptionTextField.text = "BOTTOM CAPTION"
        }
        textField.resignFirstResponder()
        return true
    }
    
    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imagePickedView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
        viewSetup(initialStatus: false)
        
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

    //importButton action function
    @IBAction func importButton(_ sender: Any) {
        
        //Create instance of UIAlertController with title and message
        let importController = UIAlertController()
        importController.title = "Import image"
        importController.message = "Pick your best image to generate meme"
        
        //Setup import from Photo Library Action
        let importFromPhotoLibraryAction = UIAlertAction(title: "Import from Photo Library", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
            self.pickAnImageFromMediaLibrary()
        }
        
        //Setup import from camera action
        let importFromCameraAction = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.default) {
            action in
            self.dismiss(animated: true, completion: nil)
            self.pickAnImageFromCamera()
        }
        
        importFromCameraAction.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Setup cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        
        //Tells importButton to add actions
        importController.addAction(importFromPhotoLibraryAction)
        importController.addAction(importFromCameraAction)
        importController.addAction(cancelAction)
        
        //Tells importButton to present importController when it is tapped
        self.present(importController, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide Toolbar and Navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topCaption: topCaptionTextField.text!, bottomCaption: bottomCaptionTextField.text!, originalImage: imagePickedView.image!, memedImage: generateMemedImage())
        
        let image = meme.memedImage
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(nextController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
        save()
    }

    //Keyboard adjustments
    
    //Setup view before keyboard appeared
    func keyboardWillAppear(_ notification:Notification) {
        if bottomCaptionTextField.isEditing == true {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    //Setup view before keyboard disappeared
    func keyboardWillDisappear(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    //Getting keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Subscribing to notifications to execute functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //Unsubscribing from notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

struct Meme {
    var topCaption: String
    var bottomCaption: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topCaption: String, bottomCaption: String, originalImage: UIImage, memedImage: UIImage) {
        self.topCaption = topCaption
        self.bottomCaption = bottomCaption
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
