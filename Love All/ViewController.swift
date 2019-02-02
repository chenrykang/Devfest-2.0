//
//  TableViewController.swift
//  Love All
//
//  Created by Christopher Kang on 1/5/19.
//  Copyright © 2019 Christopher Kang. All rights reserved.
//

import UIKit

struct CellData {
    let image: UIImage?
    let message: String?
}

class TableViewController: UITableViewController{
    var data = [CellData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [CellData.init(image: #imageLiteral(resourceName: "test2"), message: "Hurricane Relief"), CellData.init(image: #imageLiteral(resourceName: "test2"), message: ""), CellData.init(image: #imageLiteral(resourceName: "test2"), message: "FUCKING WORK, PLEASE"), CellData.init(image: #imageLiteral(resourceName: "test2"), message: "FUCKING WORK, PLEASE"), CellData.init(image: #imageLiteral(resourceName: "test2"), message: "FUCKING WORK, PLEASE")]
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
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
