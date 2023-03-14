//
//  ViewController.swift
//  MemeMe
//
//  Created by MacBook Pro on 14.09.22.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet var memeNavigationBar: UINavigationBar!
    @IBOutlet var mainToolBar: UIToolbar!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTF: UITextField!
    @IBOutlet var botTF: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    var memedImage: UIImage!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5
    ]
    
    func prepareTextField(textField: UITextField, defaultText: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareTextField(textField: topTF, defaultText: "TOP")
        prepareTextField(textField: botTF, defaultText: "BOTTOM")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        #if targetEnvironment(simulator)
            cameraButton.isEnabled = false
        #else
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #endif
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func topEdititngDidBegin(_ sender: Any) {
        if topTF.text == "Top" {
            topTF.text = ""
            
        }
    }
    @IBAction func botEdititngDidBegin(_ sender: Any) {
        if botTF.text == "Bottom" {
            botTF.text = ""
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
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        if botTF.isFirstResponder{
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
        let meme: Meme = Meme(topText: topTF.text!, bottomText: botTF.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemmedImage() -> UIImage {
        
        memeNavigationBar.isHidden = true
        mainToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        memeNavigationBar.isHidden = false
        mainToolBar.isHidden = false
        
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
