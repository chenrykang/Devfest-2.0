//
//  TableViewController.swift
//  Love All
//
//  Created by Christopher Kang on 1/5/19.
//  Copyright © 2019 Christopher Kang. All rights reserved.
//

import UIKit
import Firebase

struct CellData {
    let image: UIImage?
    let title: String?
    let message: String?
}

class TableViewController: UITableViewController{
    var data = [CellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // only need to fetch once so use single event
        
        let ref = Database.database().reference().child("Posts").child("Post1").child("Description")
        
        ref.observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard let Description = snapshot.value as? String else {
                print("Value is Nil or not String")
                return
            }
            print(Description)
           
        })
        
        data = [CellData.init(image: #imageLiteral(resourceName: "fooddrive"), title: "Food Drive", message: "Food Drive \nNew York City"), CellData.init(image: #imageLiteral(resourceName: "walkathon"), title: "Charity Walk", message: "Fundraising Walkathon\nNew Jersey"), CellData.init(image: #imageLiteral(resourceName: "test3"), title: "Title3", message: "Hurricane Relief Donation \nConnecticut")]
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "123", sender: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.mainImage = data[indexPath.row].image
        cell.textLabel!.text = self.data[indexPath.row].title
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size:15)
        cell.message = data[indexPath.row].title
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
