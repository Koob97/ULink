//
//  TableViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/16/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class courseCell: UITableViewCell{
    var parentView = TableViewController()
    
    var courseNumber = String()
    
    @IBOutlet var button: UIButton!
    var info = [String: Any]()
    
    @IBAction func displayData(_ sender: UIButton!){
        let info_string = "Name: \(info["course_name"]!) \n Days: \((info["days"]! as! [String]).joined(separator: " ")) \n Start Time: \(info["start_time"]!) \n End Time: \(info["end_time"]!) \n Location: \(info["location"]!) "
        
        displayAlertMessage(msg: info_string)
        if let currentIndex = parentView.tableView.indexPathForSelectedRow {
            parentView.table.delegate?.tableView!(parentView.table, didDeselectRowAt: currentIndex)
        }
        let selectedIndex = IndexPath(row: sender.tag, section: 0)
        parentView.tableView.selectRow(at: selectedIndex, animated: false, scrollPosition: .none)
        parentView.table.delegate?.tableView!(parentView.table, didSelectRowAt: selectedIndex)
    }
    
    func displayAlertMessage(msg: String){
        let alert = UIAlertController(title: (self.textLabel?.text!)!, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "close", style: .destructive, handler: nil)
        
        let addCourse = UIAlertAction(title: "add course", style: .default, handler: { action in
            let confirmation = UIAlertController(title: "Confirmation of Enrollment", message: "Confirming this will add this course to your list of classes and will alter your schedule", preferredStyle: .actionSheet)
            let confirm = UIAlertAction(title: "confirm", style: .default, handler: { action in
                self.addCourseToUser(uuid: self.parentView.userID!)
            })
            let cancel = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
            confirmation.addAction(confirm)
            confirmation.addAction(cancel)
            self.parentView.present(confirmation, animated: true, completion: nil)
        })
        alert.addAction(addCourse)
        alert.addAction(okAction)
        parentView.present(alert, animated: true, completion: nil)
    }
    
    func addCourseToUser(uuid: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var courses = [String]()
        ref.child("users").child(uuid).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                if value?["courses"] != nil {
                    courses = value?["courses"] as! [String]
                    courses.append(self.courseNumber)
                }
                else {
                    courses.append(self.courseNumber)
                }
            
                ref.child("users/\(uuid)/courses").setValue(courses, withCompletionBlock: { (err, dbRef) in
                    self.parentView.tabController.update()
                })
        
        })
    }
}

class TableViewController: UITableViewController {
    var homeView = HomeViewController()
    
    let userID = Auth.auth().currentUser?.uid
    var myArray = [String]()
    var tabController: TabController!
    
    @IBOutlet var table: UITableView!
    
    var dictionary = [String: Any](){
        didSet {
            myArray = Array(dictionary.keys).sorted(by: <)
            if table != nil{
                table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabController = tabBarController as! TabController
        dictionary = tabController.courseDict
        let view1: UIView = UIView.init(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:100))
        let label: UILabel = UILabel.init(frame: CGRect(x:0, y:0, width: self.view.frame.width, height:100))
        label.text = "Course Listings"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        view1.addSubview(label)
        self.tableView.tableHeaderView = view1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as! courseCell
            cell.textLabel?.textColor = .black
            cell.button.tintColor = .black
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath) as! courseCell
            cell.textLabel?.textColor = .white
            cell.button.tintColor = .white
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! courseCell
        
        cell.textLabel?.text = "CMPSCI " + myArray[indexPath.item]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 0.0)
        cell.addSubview(cell.button)
        cell.courseNumber = myArray[indexPath.item]
        cell.info = dictionary[myArray[indexPath.item]] as! [String : Any]
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
