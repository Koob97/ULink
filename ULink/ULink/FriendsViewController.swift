//
//  FriendsViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 11/3/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    var friendsNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 1.0)
        picker.delegate = self
        picker.dataSource = self
        //picker.setValue(UIColor.white, forKeyPath: "textColor")
        let tabController = tabBarController as! TabController
        let users = tabController.dataDict["users"] as! [String: [String: Any]]
        var friendsList = users[tabController.UUID]?["friends"]
        if(friendsList != nil){
            friendsList = (friendsList as! [String]).sorted()
            for friend in friendsList as! [String]{
                let username = users[friend]?["username"] as! String
                friendsNames.append(username)
            }
        }
        
        //popup set up
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        courseDetail.layer.cornerRadius = 5
        //end popup setup
        courseArray = users[(friendsList as! [String])[0]]?["courses"] as! [String]
        updateData(controller: tabController)
        scrollView.delegate = self
        days = createDays()
        setupDayScrollView(days: days)
        
        pageControl.numberOfPages = days.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return friendsNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let friend = friendsNames[row]
        let text = NSAttributedString(string: friend, attributes: [NSForegroundColorAttributeName: UIColor.white])
        return text
    }
    
    //SCHEDULE FUNCTIONALITY WITH COPIED CODE
    var data: [String: [String]] = [
        "Mon": [],
        "Tue": [],
        "Wed": [],
        "Thu": [],
        "Fri": []
    ]
    
    var classLengthsAndStart: [String: [Int]] = [:]
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect: UIVisualEffect!
    
    @IBOutlet var courseDetail: UIView!
    
    var courseArray: [String] = [String]()
    
    @IBAction func close(_ sender: AnyObject) {
        togglePopUp(sender: sender)
    }
    
    func animateIn(){
        view.bringSubview(toFront: visualEffectView)
        self.view.addSubview(courseDetail)
        courseDetail.center = self.view.center
        courseDetail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        courseDetail.alpha = 0
        
        UIView.animate(withDuration: 0.3){
            self.visualEffectView.effect = self.effect
            self.courseDetail.alpha = 1
            self.courseDetail.transform = CGAffineTransform.identity
        }
    }
    @IBOutlet weak var popUpText: UITextView!
    
    @IBAction func togglePopUp(sender: AnyObject){
        if(visualEffectView.effect == nil){
            let classNum = sender.tag
            let dayNum = pageControl.currentPage
            var day = ""
            switch(dayNum){
            case 0: day = "Mon"
            case 1: day = "Tue"
            case 2: day = "Wed"
            case 3: day = "Thu"
            case 4: day = "Fri"
            default: print("error in page control number")
            }
            let className = data[day]?[classNum!]
            
            let tabController = tabBarController as! TabController
            let info = tabController.courseDict[className!] as! [String: Any]
            let info_string = "Name: \(info["course_name"]!) \n Days: \((info["days"]! as! [String]).joined(separator: " ")) \n Start Time: \(info["start_time"]!) \n End Time: \(info["end_time"]!) \n Location: \(info["location"]!) "
            popUpText.text = info_string
            animateIn()
        }
        else {
            animateOut()
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.courseDetail.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.courseDetail.alpha = 0
            self.visualEffectView.effect = nil
        }){ (success: Bool) in
            self.courseDetail.removeFromSuperview()
            self.view.bringSubview(toFront: self.scrollView)
            self.view.bringSubview(toFront: self.pageControl)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func updateData(controller: TabController){
        data = [
            "Mon": [],
            "Tue": [],
            "Wed": [],
            "Thu": [],
            "Fri": []
        ]
        classLengthsAndStart = [:]
        let courseDict = controller.courseDict
        for course in courseArray {
            let courseInfo = courseDict[course] as! [String: Any]
            for day in courseInfo["days"] as! [String] {
                data[day]?.append(course)
            }
            
            let startTime = courseInfo["start_time"] as! String
            let endTime = courseInfo["end_time"] as! String
            let classLength = timeToMinutes(string: endTime) - timeToMinutes(string: startTime)
            
            //start time is subtracted by 8 hours because the schedule starts at 8:00 AM
            classLengthsAndStart[course] = [timeToMinutes(string: startTime) - 60*8, classLength]
        }
        
        //replace old day views in scroll view with new ones
        let newDays = createDays()
        setupDayScrollView(days: newDays)
    }
    
    func timeToMinutes(string: String) -> Int{
        let times = string.components(separatedBy: ":")
        let secondHalf = times[1].components(separatedBy: " ")
        let flag = secondHalf[1]=="AM" || times[0]=="12"
        return 60*Int(times[0])! + Int(secondHalf[0])! + (flag ? 0:12*60)
    }
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var days: [UIView] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    func createDays() -> [UIView] {
        let monday = generateDayView(dayName: "Monday")
        let tuesday = generateDayView(dayName: "Tuesday")
        let wednesday = generateDayView(dayName: "Wednesday")
        let thursday = generateDayView(dayName: "Thursday")
        let friday = generateDayView(dayName: "Friday")
        
        return [monday, tuesday, wednesday, thursday, friday]
    }
    
    func generateDayView(dayName: String) -> UIView {
        let day = UIView(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: view.frame.size.height))
        day.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 1)
        let dayLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 100))
        dayLabel.text = dayName
        dayLabel.textAlignment = .center
        dayLabel.textColor = .white
        dayLabel.font = UIFont.systemFont(ofSize: 30.0)
        day.addSubview(dayLabel)
        
        let minY = 125
        let frameHeight = 450
        let times = ["8:00", "9:00", "10:00", "11:00", "12:00", "1:00",
                     "2:00", "3:00", "4:00", "5:00", "6:00"]
        var newLabel: UILabel
        var count = 0
        for time in times {
            newLabel = UILabel(frame: CGRect(x: 10, y: Int(CGFloat(minY) + CGFloat(count)*CGFloat(frameHeight/11) - CGFloat(10)), width: 100, height: frameHeight/11))
            newLabel.text = time
            newLabel.textColor = .white
            day.addSubview(newLabel)
            count = count + 1
        }
        let index = dayName.index(dayName.startIndex, offsetBy: 3)
        let abbrev = String(dayName.substring(to: index))
        
        var button: UIButton
        count = 0
        for course in data[abbrev!]! {
            let height = Int((Float((classLengthsAndStart[course]?[1])!)/Float(60*11))*450)
            let startOffset = Int((Float((classLengthsAndStart[course]?[0])!)/Float(60*11))*450)
            
            let y = startOffset + minY
            
            button = UIButton(frame: CGRect(x: 90, y: Int(y), width: 250, height: Int(height)))
            button.backgroundColor = UIColor(colorLiteralRed: Float(arc4random()%255)/Float(255), green: Float(arc4random()%255)/Float(255), blue: Float(arc4random()%255)/Float(255), alpha: 1)
            button.setTitle(course, for: .normal)
            button.tag = count
            button.addTarget(self, action: #selector(togglePopUp), for: .touchUpInside)
            day.addSubview(button)
            count += 1
        }
        return day
    }
    
    func setupDayScrollView(days : [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(days.count), height: view.frame.height - 100)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< days.count {
            days[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height - 100)
            scrollView.addSubview(days[i])
        }
    }
    
    


}
