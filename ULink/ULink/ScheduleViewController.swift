//
//  ScheduleViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/19/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit

class timeSlot: UITableViewCell{
    
}

class ScheduleViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var data: [String: [String]] = [
        "Mon": [],
        "Tue": [],
        "Wed": [],
        "Thu": [],
        "Fri": []
    ]
    
    var parentView: HomeViewController!
    var courseArray: [String] = [String]()
    
    func updateData(){
        data = [
        "Mon": [],
        "Tue": [],
        "Wed": [],
        "Thu": [],
        "Fri": []
        ]
        let courseDict = parentView.courseDict
        for course in courseArray {
            let courseInfo = courseDict[course] as! [String: Any]
            for day in courseInfo["days"] as! [String] {
                data[day]?.append(course)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSlot", for: indexPath) as! timeSlot

        var courses: [String] = []
        var course: String = ""
        switch tableView.tag{
        case 0: course = "default"
        case 1: courses = data["Mon"]!
            course = courses[indexPath.item]
        case 2: courses = data["Tue"]!
            course = courses[indexPath.item]
        case 3: courses = data["Wed"]!
            course = courses[indexPath.item]
        case 4: courses = data["Thu"]!
            course = courses[indexPath.item]
        case 5: courses = data["Fri"]!
            course = courses[indexPath.item]
        default:
            print("default case")
        }
        let cellLabel = UILabel(frame: CGRect(x: 10.0, y: 4.0, width: 150.0, height: 30.0))
        cellLabel.text = course
        cell.addSubview(cellLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height/11;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let table = tableView as! tableSchedule
        var courses: [String] = []
        switch tableView.tag {
        case 1: courses = data["Mon"]!
           
        case 2: courses = data["Tue"]!
          
        case 3: courses = data["Wed"]!
       
        case 4: courses = data["Thu"]!
        
        case 5: courses = data["Fri"]!
       
        default:
            return 0
        }
        
         return courses.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var days: [day] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    func createDays() -> [day] {
        let monday = generateDayView(dayName: "Monday")
        let tuesday = generateDayView(dayName: "Tuesday")
        let wednesday = generateDayView(dayName: "Wednesday")
        let thursday = generateDayView(dayName: "Thursday")
        let friday = generateDayView(dayName: "Friday")
        
        return [monday, tuesday, wednesday, thursday, friday]
    }
    
    func generateDayView(dayName: String) -> day {
        let day: day = Bundle.main.loadNibNamed("day", owner: self, options: nil)?.first as! day
        day.dayLabel.text = dayName
        
        let dayTable = UITableView()
        dayTable.frame = CGRect(x: 75, y:150, width: 250, height: 450)
        //dayTable.separatorStyle = .none
        
        dayTable.delegate = self
        dayTable.dataSource = self
        dayTable.register(timeSlot.self, forCellReuseIdentifier: "timeSlot")
        switch dayName {
            case "Monday": dayTable.tag = 1
            case "Tuesday": dayTable.tag = 2
            case "Wednesday": dayTable.tag = 3
            case "Thursday": dayTable.tag = 4
            case "Friday": dayTable.tag = 5
        default:
            print("invalid day so no tag assigned")
        }
        day.addSubview(dayTable)
        let times = ["8:00", "9:00", "10:00", "11:00", "12:00", "1:00",
                     "2:00", "3:00", "4:00", "5:00", "6:00"]
        var newLabel: UILabel
        var count = 0
        for time in times {
           
            newLabel = UILabel(frame: CGRect(x: 10, y: dayTable.frame.minY + CGFloat(count)*dayTable.frame.height/11, width: 100, height: dayTable.frame.height/11))
            newLabel.text = time
            day.addSubview(newLabel)
            count = count + 1
        }
        return day
    }
    
    func setupDayScrollView(days : [day]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(days.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< days.count {
            days[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(days[i])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        scrollView.delegate = self
        days = createDays()
        setupDayScrollView(days: days)
        
        pageControl.numberOfPages = days.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
        // Do any additional setup after loading the view.
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
