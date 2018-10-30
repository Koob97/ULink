//
//  MyCoursesViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/17/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class myCourseCell: UITableViewCell{
    var parentView = MyCoursesViewController()
    
    @IBOutlet weak var button: UIButton!
    
}


class MyCoursesViewController: UITableViewController {
    
    var courseArray = [String](){
        didSet{
            if(table != nil){
                table.reloadData()
            }
        }
    }
    
    
    @IBOutlet var table: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded!")
        let tabController = tabBarController as! TabController
        courseArray = tabController.courseArray
        let view1: UIView = UIView.init(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:100))
        let label: UILabel = UILabel.init(frame: CGRect(x:0, y:0, width: self.view.frame.width, height:100))
        label.text = "Your Courses"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        view1.addSubview(label)
        self.tableView.tableHeaderView = view1
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursecell", for: indexPath) as! myCourseCell
        
        cell.textLabel?.text = "CMPSCI " + courseArray[indexPath.item]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(colorLiteralRed: 0.533333, green: 0.1098, blue: 0.1098, alpha: 0.0)
        
        cell.addSubview(cell.button)
        cell.parentView = self
        cell.button.tag = indexPath.row
        
        // Configure the cell...
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
