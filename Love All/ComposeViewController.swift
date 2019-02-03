//
//  ComposeViewController.swift
//  CollegeParty
//
//  Created by Christopher Kang on 9/27/18.
//  Copyright © 2018 Christopher Kang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import Photos

class ComposeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var EventNameText: UITextField!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var DateTimeText: UITextField!
    var datePicker : UIDatePicker?
    @IBOutlet weak var image: UIImageView!
    
    var ref: DatabaseReference?
    
    let picker = UIImagePickerController()
    
    
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
        
        ref = Database.database().reference()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        DateTimeText.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(ComposeViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ComposeViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        
        picker.delegate = self
        checkPermission()
        
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        image.isUserInteractionEnabled = true
    }
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
            image.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateTimeText.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneIsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toEvent", sender: self)
        
        self.ref?.child("Posts").child("Post1").child("Title").setValue(EventNameText.text)
        self.ref?.child("Posts").child("Post1").child("Description").setValue(DescriptionText.text)
        self.ref?.child("Posts").child("Post1").child("DateTime").setValue(DateTimeText.text)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEvent" {
            let DestComposeViewController: EventPageViewController = segue.destination as! EventPageViewController
            
            DestComposeViewController.EventNameText = self.EventNameText.text!
            DestComposeViewController.EventDescriptionText = self.DescriptionText.text!
            DestComposeViewController.DateTimeText = self.DateTimeText.text!
            DestComposeViewController.eventPicture = self.image.image!
        }
        
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
