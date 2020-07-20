//
//  ViewController.swift
//  MemeMe1
//
//  Created by Sarah Alhabib on 11/10/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var buttomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0 //negative value to make the foregroundColor appear, this solution is suggisted by a coleague
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, "TOP")
        setupTextField(buttomTextField, "BOTTOM")
        
        // disable share button before choosing a picture
        shareButton.isEnabled=false
        
    }
    
    func setupTextField(_ textField: UITextField, _ defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.backgroundColor=UIColor.clear
        textField.borderStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: clear the textFields when start editting
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text=="TOP" || textField.text=="BOTTOM"{
            textField.text=""
        }
        
    }
    
    // MARK: Pick image
    
    func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self;
        controller.sourceType = source
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageFromAlbum() {
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(){
        pickFromSource(.camera)
    }
    
    //when the user pick an image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image=pickedimage
        }
        
        //enable share button
        shareButton.isEnabled=true
        
        dismiss(animated: true, completion: nil)
    }
    
    //when the user click cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard
    //to dismiss the keyboard after press enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //to shift the keyboard when editting the buttom text field
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if buttomTextField.isEditing{ //this line is suggisted by a colleague
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if buttomTextField.isEditing{
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // MARK: Save the memedImage
    func save(){
        let meme = Meme(topText: topTextField.text!, buttomText: buttomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // add it to to the appdelegate memes array
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide tool and navigation bars
        navBar.isHidden=true
        toolBar.isHidden=true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show tool and navigation bars
        navBar.isHidden=false
        toolBar.isHidden=false
        
        return memedImage
    }
    
    //MARK: Share button
    //present activity view
    @IBAction func share(){
        let image=generateMemedImage()
        let controller=UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        //line 197 and 198 to solve activityView problem on iPad from https://stackoverflow.com/questions/32889680/uiactivityviewcontroller-on-ipad
        controller.popoverPresentationController?.sourceView=self.view
        controller.popoverPresentationController?.sourceRect=shareButton.accessibilityFrame
        
        present(controller, animated: true, completion: nil)
        
        // I learned how to use completionWithItemsHandler from https://www.swiftdevcenter.com/uiactivityviewcontroller-tutorial-by-example/
        controller.completionWithItemsHandler = {(_: UIActivity.ActivityType?, completed: Bool, _: [Any]?,_: Error?) in
            if completed {
                self.save()
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // to return to the Sent Memes View
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
