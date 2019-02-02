//
//  ComposeViewController.swift
//  CollegeParty
//
//  Created by Christopher Kang on 9/27/18.
//  Copyright © 2018 Christopher Kang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var hostView: UITextField!
    
     var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPost(_ sender: Any) {
    ref?.child("Posts").child("Post1").child("Title").setValue(titleView.text)
    ref?.child("Posts").child("Post1").child("Host").setValue(hostView.text)
        
    ref?.child("Posts").child("Post1").child("Details").setValue(textView.text)
    }
    
    @IBAction func cancelPost(_ sender: Any) {
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
