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
    
    
    //VARIABLES//
    
    var updatedY = CGFloat()
    
    @IBOutlet weak var imagePickedView: UIImageView!
    @IBOutlet weak var topCaptionTextField: UITextField!
    @IBOutlet weak var bottomCaptionTextField: UITextField!
    @IBOutlet weak var helpingInformationLabel: UILabel!
    @IBOutlet weak var shareButtonOutlet: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var libraryButtonOutlet: UIBarButtonItem!
    
    //Constraints for Image View
    @IBOutlet weak var equalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var equalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticallyCenteredConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var aspectRatio: NSLayoutConstraint!
    
    //Attributes for Meme Words
    
    let memeTextAttributesPotrait:[String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: -4.0]
    
    let memeTextAttributesLandscape:[String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 23)!,
        NSStrokeWidthAttributeName: -4.0]
    
    
    //OVERRIDING FUNCTIONS//
    
    //Overriding Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        updatedY = view.frame.origin.y - self.imagePickedView.frame.origin.y
        
        subscribeToKeyboardNotifications()
        subscribeToOrientationNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topCaptionTextField.delegate = self
        bottomCaptionTextField.delegate = self
        
        viewSetup(initialStatus: true)
        libraryButtonOutlet.isEnabled = false
        textFieldTextAttributesPotraitSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeToOrientationNotification()
    }
    
    func deviceDidRotate(_ notification: NSNotification) -> Void {
        
        switch UIDevice.current.orientation {
        case .portrait:
            potraitMode()
        default:
            landscapeMode()
        }
    }
    
    //FUNCTIONS//
    
    //Adjust view layout
    
    //For landscape mode
    func landscapeMode() {
        textFieldTextAttributesLandscapeSetup()
        
        view.removeConstraint(equalWidthConstraint)
        view.addConstraint(equalHeightConstraint)
    }
    
    //For potraitmode
    func potraitMode() {
        textFieldTextAttributesPotraitSetup()
        
        view.removeConstraint(equalHeightConstraint)
        view.addConstraint(equalWidthConstraint)
    }
    
    //Adjusting function
    func adjustViewLayout() {
        switch UIDevice.current.orientation {
        case .portrait:
            potraitMode()
        case .portraitUpsideDown:
            potraitMode()
        default:
            landscapeMode()
        }

    }
    
    //Tells delegate to limit textfield for 23 max chars
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return newText.length <= 23
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
            imagePickedView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
        viewSetup(initialStatus: false)
        
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //USER INTERFACE SETUP//

    //Setup Text Field Text Attributes
    func textFieldTextAttributesPotraitSetup() {
        topCaptionTextField.defaultTextAttributes = memeTextAttributesPotrait
        topCaptionTextField.textAlignment = .center
        bottomCaptionTextField.defaultTextAttributes = memeTextAttributesPotrait
        bottomCaptionTextField.textAlignment = .center
    }
    
    func textFieldTextAttributesLandscapeSetup() {
        topCaptionTextField.defaultTextAttributes = memeTextAttributesLandscape
        topCaptionTextField.textAlignment = .center
        bottomCaptionTextField.defaultTextAttributes = memeTextAttributesLandscape
        bottomCaptionTextField.textAlignment = .center
    }
    
    //Setup view
    func viewSetup(initialStatus: Bool) -> Void {
        topCaptionTextField.isHidden = initialStatus
        bottomCaptionTextField.isHidden = initialStatus
        helpingInformationLabel.isHidden = !initialStatus
        shareButtonOutlet.isEnabled = !initialStatus
        saveButtonOutlet.isEnabled = !initialStatus
    }
    
    //Setup UIImagePickerController
    func setupImagePickerController(sourceType: UIImagePickerControllerSourceType) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    //HELPERS//
    
    //Picking an image action from Media Library
    func pickAnImageFromMediaLibrary() {
        setupImagePickerController(sourceType: .photoLibrary)
    }
    
    //Picking an image action from Camera
    func pickAnImageFromCamera() {
        setupImagePickerController(sourceType: .camera)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide Toolbar and Navbar
        navigationController?.setNavigationBarHidden(true, animated: true)
        toolbar.isHidden = true
        mainView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.0)
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.0)
        UIApplication.shared.isStatusBarHidden = true
        
        // Render view to an image
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 3.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //TODO: Show toolbar and navbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        toolbar.isHidden = false
        mainView.backgroundColor = UIColor.lightGray.withAlphaComponent(1.0)
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(1.0)
        UIApplication.shared.isStatusBarHidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topCaption: topCaptionTextField.text!, bottomCaption: bottomCaptionTextField.text!, originalImage: imagePickedView.image!, memedImage: memedImage)
        //Appending meme to the array of meme
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        
        libraryButtonOutlet.isEnabled = true
    }
    
    //ACTIONS//
    
    //importButton action function
    @IBAction func importButton(_ sender: Any) {
        
        //Create instance of UIAlertController with title and message
        let importController = UIAlertController()
        importController.title = "Import image"
        importController.message = "Pick your best image to generate meme"
        
        //Setup import from Photo Library Action
        let importFromPhotoLibraryAction = UIAlertAction(title: "Import from Photo Library", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromMediaLibrary()
        }
        
        //Setup import from camera action
        let importFromCameraAction = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.default) {
            action in
            importController.dismiss(animated: true, completion: nil)
            self.pickAnImageFromCamera()
        }
        
        importFromCameraAction.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Setup cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in
            importController.dismiss(animated: true, completion: nil)
        }
        
        //Tells importButton to add actions
        importController.addAction(importFromPhotoLibraryAction)
        importController.addAction(importFromCameraAction)
        importController.addAction(cancelAction)
        
        //Tells importButton to present importController when it is tapped
        self.present(importController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let image = generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        nextController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save(memedImage: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(nextController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let image = generateMemedImage()
        save(memedImage: image)
        
        let alertController = UIAlertController(title: "Saved", message: "Your meme is saved to Meme Library", preferredStyle: UIAlertControllerStyle.alert)
        let destructiveAction = UIAlertAction(title: "Open Library", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            print("Destructive")
            self.performSegue(withIdentifier: "ToMemeLibrarySegue", sender: sender)
        }
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
            
        }
        alertController.addAction(destructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        libraryButtonOutlet.isEnabled = true
        
    }    

    //Keyboard adjustments
    
    //Setup view before keyboard appeared
    func keyboardWillAppear(_ notification:Notification) {
        if bottomCaptionTextField.isEditing == true {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
            toolbar.isHidden = true
        }
    }
    
    //Setup view before keyboard disappeared
    func keyboardWillDisappear(_ notification: Notification) {
        view.frame.origin.y = 0
        toolbar.isHidden = false
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
    
    //Subscribing to notification
    func subscribeToOrientationNotification() -> Void {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    //Unsubscribing to notificaton
    func unsubscribeToOrientationNotification() -> Void {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if shareButtonOutlet.action
//        let image = generateMemedImage()
//        save(memedImage: image)
    }
}
