//Hello my name is Naviya
//  Page1ViewController.swift
//  Love All
//
//  Created by Christopher Kang on 1/5/19.
//  Copyright © 2019 Christopher Kang. All rights reserved.
//

import UIKit
import Firebase
import Photos

class CreateProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let genderValues = ["male", "female", "other"]
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let picker = UIImagePickerController()
    
    var gender = ""
    var selected = ""
    var ref: DatabaseReference!
    
    //check photo permissions
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        picker.delegate = self
        // Do any additional setup after loading the view.
        
        selected = genderValues[0]
        
        view.addSubview(profileImageView)
        setupProfileImageView()
        
        //check photo permission
        checkPermission()
        
    }

    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        
        profileImageView.frame = CGRect(x: 230, y: 115, width: 125, height: 125)
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    @objc func handleSelectProfileImageView(){
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //save profile if button is pressed
    @IBAction func saveProfile(_ sender: Any) {
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser!.uid
        self.ref.child("Users").child(userID)
   
        let name = nameField.text
        let age = ageField.text
        let city = cityField.text
        
        self.ref.child("Users").child(userID).child("Name").setValue(name)
        self.ref.child("Users").child(userID).child("Age").setValue(age)
        self.ref.child("Users").child(userID).child("City").setValue(city)
        
        let gender = selected
            
        self.ref.child("Users").child(userID).child("Gender").setValue(gender)
        
        //perfom segue to home
        self.performSegue(withIdentifier: "toHome", sender: self)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selected = genderValues[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderValues[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
