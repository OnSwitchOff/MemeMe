//
//  ViewController.swift
//  MemeMe
//
//  Created by MacBook Pro on 14.09.22.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet var MainNavigationBar: UINavigationBar!
    @IBOutlet var MainToolBar: UIToolbar!
    @IBOutlet var ImagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var TopTF: UITextField!
    @IBOutlet var BotTF: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    var memedImage: UIImage!
    var meme: Meme!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth: 2
    ]
    
    func prepareTextField(textField: UITextField, defaultText: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTextField(textField: TopTF, defaultText: "TOP")
        prepareTextField(textField: BotTF, defaultText: "BOTTOM")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        #if targetEnvironment(simulator)
            cameraButton.isEnabled = false
        #else
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func topEdititngDidBegin(_ sender: Any) {
        if TopTF.text == "Top" {
            TopTF.text = ""
            
        }
    }
    @IBAction func botEdititngDidBegin(_ sender: Any) {
        if BotTF.text == "Bottom" {
            BotTF.text = ""
        }
    }
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if BotTF.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() -> Void  {
        meme = Meme(topText: TopTF.text!, bottomText: BotTF.text!, originalImage: ImagePickerView.image!, memedImage: memedImage!)
    }
    
    func generateMemmedImage() -> UIImage {
        
        MainNavigationBar.isHidden = true
        MainToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        MainNavigationBar.isHidden = false
        MainToolBar.isHidden = false
        
        return memedImage;
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemmedImage()
        let items = [memedImage]
        let activityViewController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems:[Any]?, error: Error?) in
            if completed {
                self.save()
            }
            activityViewController.dismiss(animated: true)
        }
    }
}
