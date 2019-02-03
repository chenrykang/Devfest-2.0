//
//  ComposeViewController.swift
//  CollegeParty
//
//  Created by Christopher Kang on 9/27/18.
//  Copyright © 2018 Christopher Kang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var EventNameText: UITextField!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var DateTimeText: UITextField!
    var datePicker : UIDatePicker?
    
    var ref: DatabaseReference?
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEvent" {
            let DestComposeViewController: EventPageViewController = segue.destination as! EventPageViewController
            
            DestComposeViewController.EventNameText = self.EventNameText.text!
            DestComposeViewController.EventDescriptionText = self.DescriptionText.text!
            DestComposeViewController.DateTimeText = self.DateTimeText.text!
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
