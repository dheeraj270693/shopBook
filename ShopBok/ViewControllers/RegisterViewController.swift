//
//  RegisterViewController.swift
//  ClassBook
//
//  Created by Dheeraj Gupta on 2019-09-14.
//  Copyright © 2019 Dheeraj Gupta. All rights reserved.
//

import UIKit
import  MobileCoreServices

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var currentProfile : Profile?
    var datePicker: UIDatePicker?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated:true)
    }
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBAction func uploadBtnClicked(_ sender: UIButton) {
        if allFieldsOk(){
            
            let uid = currentProfile!.uid
            let myManager = FirebaseManager()
            let myStorageManager = StorageManager()
            let myImage = profileImageView.image ?? UIImage(named: defaultImage)
            let myImageData = myImage?.jpegData(compressionQuality: 1)
            
            myStorageManager.uploadProfileImage(userID: uid, data: myImageData!) { (success, url) in
                if success{
                    let myProfile = Profile(uid: self.currentProfile!.uid, name: self.fullnameTextField.text!, email: self.emailTextField.text!, birthday: self.birthdayTextField.text!, pic: url!)
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(myProfile) {
                        UserDefaults.standard.set(encoded, forKey: "currentProfile")
                    }
                    myManager.uploadProfile(userId: uid, dict: myProfile.getDict())
                    //DispatchQueue.main.async {
                    //showAlert(viewController: self, "Updated the profile...")
                    let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    homeVC.selectedIndex = 0
                    self.present(homeVC, animated: true, completion: nil)
                    // }
                }else {
                    print("error adding user to database")
                }
            }
        }
    }
    
    func allFieldsOk()-> Bool{
        let haveText = fullnameTextField.hasText && emailTextField.hasText && birthdayTextField.hasText
        return haveText
    }
    
    //    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialisingVariables()
        addingNotifications()
        setUpUserDetails()
    }
    
    @objc func dateValueChanged(picker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        birthdayTextField.text = dateFormatter.string(from: picker.date)
    }
    
    func initialisingVariables(){
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        birthdayTextField.delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        birthdayTextField.inputView = datePicker
    }
    
    func addingNotifications(){
        //Keyboard moving functionality part 1 /3....
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //end of Keyboard moving functionality part 1 ....
    }
    
    //    MARK: Set User Details
    func setUpUserDetails(){
        if let savedPerson = UserDefaults.standard.object(forKey: "currentProfile") as? Data
        {
            let decoder = JSONDecoder()
            currentProfile = try? decoder.decode(Profile.self, from: savedPerson)
            if currentProfile!.name != "New User" {
                fullnameTextField.text = currentProfile!.name
                fullnameTextField.isEnabled = false
                emailTextField.text = currentProfile!.email
                birthdayTextField.text = currentProfile!.birthday
                profileImageView.setImageFromUrl(myUrl: currentProfile!.pic)
            }else{
                fullnameTextField.isEnabled = true
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage{
            profileImageView.image = image
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Keyboard moving functionality part 2/3....
    @objc func keyboardWillShow(notification: NSNotification){
        keyboardShow(vc: self, notification: notification)
    }
    @objc func keyboardWillHide(notification: NSNotification){
        keyboardHide(vc: self, notification: notification)
        
    }
    //end of Keyboard moving functionality part 2....
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
