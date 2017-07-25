//
//  ViewController.swift
//  abcd
//
//  Created by Naveen Vijay on 25/03/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
    ////////////////////////////calendar
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableData: UITableView!
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    /*fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calendar.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.headerDateFormat = "MMMM yyyy"
                self.calendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.darkGray
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy-MM";
                self.calendar.appearance.todayColor = UIColor.red
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.red
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy/MM"
                self.calendar.appearance.todayColor = UIColor.orange
                self.calendar.appearance.borderRadius = 0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }*/
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    //fileprivate let datesWithCat = ["2015/05/05","2015/06/05","2015/07/05"]
    
    //let lunarCalendar = NSCalendar(calendarIdentifier: .chinese)!
    //let lunarChars = ["1","100","200"]
    
    ////////////////////////////////////
    
    
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var testDb = [NSManagedObject]()
    var calenderDate = [NSManagedObject]()
    var num = [Int]()
    //var aa = [Int]()
    
    var nameArray = [String]()
    var dateArray = [String]()
    var repArray = [Int]()
    var hourArray = [Int]()
    var minuteArray = [Int]()
    //var countFlag = false
    //var dateFlag = false
    var a = false
    var stopDB = false
    
    var saveDate = String()
    var saveDay = String()
    var saveMonth = String()
    var saveYear = String()
    var startDate = String()
    var dateTitle = String()
    var compareDate = String()
    var newDate = Date()
    
    //var count: Int = 0
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tabBarController?.tabBar.isHidden = true
        defaults.set("", forKey: "defaultDate")
        var cellNib = UINib(nibName: TableViewNibCell.ViewControllerCell, bundle: nil)
        tableData.register(cellNib, forCellReuseIdentifier: TableViewNibCell.ViewControllerCell)
        
        cellNib = UINib(nibName: TableViewNibCell.NothingFoundCell, bundle: nil)
        tableData.register(cellNib, forCellReuseIdentifier: TableViewNibCell.NothingFoundCell)
        
        //////////////////////calendar
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        //self.calendar.select(self.formatter.date(from: "2017/03/18")!)
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        ///////// bgcolor
        //view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        tableData.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        tableData.rowHeight = 80
        //calendar.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        //fetchFromDb()
    }

    override func viewWillAppear(_ animated: Bool) {
        stopDB = false
        compareDate = ""
        //calendar.reloadData()
        fetchFromDb()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    struct TableViewNibCell {
        static let ViewControllerCell = "ViewControllerCell"
        static let NothingFoundCell = "NothingFoundCell"
    }
    
    //////////////////////
    func fetchFromDb(){
        num = []
        testDb = []
        
        if let defaultdate = defaults.value(forKey: "defaultDate") as? String{
            if defaultdate == ""{
                print("ddd null",startDate)
            }else{
                print("ddd",defaultdate,startDate)
                startDate = defaultdate
            }
        }
        
        if startDate != "" {
            let dateString = startDate // change to your date format
            print("new start", startDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            //dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateee = dateFormatter.date(from: dateString)!
            print("new date",dateee)
            newDate = dateee
        }
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        var startOfMonth = Calendar.current.date(from: comp)!
        let startDateLocal = dateFormatter.string(from: startOfMonth)
        //print("start of month11", startOfMonth/*, comp.day!,*/ ,startOfMonth,comp.year!)
        
        if startDate != ""{
            startOfMonth = newDate
        }
        
        //print("start date \(startDateLocal,dateFormatter.string(from: startOfMonth))")
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)!
        let endDate = dateFormatter.string(from: endOfMonth)
        //print("sssss",endOfMonth!,endDate)
        //print("end date \(endDate,dateFormatter.string(from: endOfMonth!))")
        
        if startDate == ""{
            startDate = startDateLocal
            print("/////new////656565",startDate,endDate,startOfMonth)
        }
        
        //////////////////////////////////
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        dateFormatter.dateFormat = "dd"
        let b = dateFormatter.string(from: startOfMonth)
        //print("bbbbbbbbb", b)
        let bb = dateFormatter.string(from: endOfMonth)
        //print("endbbbbbbbbb", bb)
        
        dateFormatter.dateFormat = "MM"
        let c = dateFormatter.string(from: startOfMonth)
        //print("bbbbbbbbb", c)
        
        dateFormatter.dateFormat = "yyyy"
        let d = dateFormatter.string(from: startOfMonth)
        //print("bbbbbbbbb", d)
        
        let pred = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", b, bb, c, d)
        fetchRequest.predicate = pred
        
        do{
            testDb = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            print("count",testDb.count)
            
            for i in testDb {
                //print("name \(i.value(forKey: "name")!)")
                print(i.value(forKey: "number")!)
                //print(i.value(forKey: "date")!)
                //print(i.value(forKey: "saveday")!)
                //print(i.value(forKey: "savemonth")!)
                //print(i.value(forKey: "saveyear")!)
                
                let a = i.value(forKey: "number")
                
                num.append(Int(a as! Int16))
                //print("aaaa",num.count)
            }
            
            //////remove duplicate values from array
            
            num = Array(Set(num))
            
            for i in num {
                print("nummmm", i)
            }
            
        }catch{
            print(error)
        }
       // [calendar.setNeedsDisplay()]
        startDate = ""
        calendar.reloadData()
        print("after load", startDate,endDate,num.count)
    }
    
    func loadDb(){
        print("load with current date")
        stopDB = true
        calenderDate = []
        nameArray = []
        dateArray = []
        repArray = []
        hourArray = []
        minuteArray = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        let predicate = NSPredicate(format: "date == %@", saveDate)
        fetchRequest.predicate = predicate
        
        do {
            calenderDate = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        
        for i in calenderDate{
            nameArray.append(i.value(forKey: "name") as! String)
            dateArray.append(i.value(forKey: "date") as! String)
            repArray.append(i.value(forKey: "repetition") as! Int)
            hourArray.append(i.value(forKey: "hour") as! Int)
            minuteArray.append(i.value(forKey: "minute") as! Int)
        }
        tableData.reloadData()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateTitle = dateFormatter.string(from: date)
        print("aaabbbbbbbbb", dateTitle)
    }
    
    ///////////////////////////////calendar////////////////////////////////
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        //return self.gregorian.isDateInToday(date) ? "今天" : nil
        //print("cudaaaa",self.gregorian.date)
       /* let oldDate = self.formatter.string(from: date)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        let showDate = inputFormatter.date(from: oldDate)
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate!)
             print("-----/",resultString)*/
        
        //////////// coredata
        if stopDB == false {
            
            print("load with current date")
            stopDB = true
            calenderDate = []
            nameArray = []
            dateArray = []
            repArray = []
            hourArray = []
            minuteArray = []
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
             
            let predicate = NSPredicate(format: "date == %@", saveDate)
            fetchRequest.predicate = predicate
             
            do {
                calenderDate = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            } catch {
                print(error)
            }
             
            for i in calenderDate{
                nameArray.append(i.value(forKey: "name") as! String)
                dateArray.append(i.value(forKey: "date") as! String)
                repArray.append(i.value(forKey: "repetition") as! Int)
                hourArray.append(i.value(forKey: "hour") as! Int)
                minuteArray.append(i.value(forKey: "minute") as! Int)
            }
            tableData.reloadData()
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            dateTitle = dateFormatter.string(from: date)
            print("aaabbbbbbbbb", dateTitle)
        }
        return self.gregorian.isDateInToday(date) ? dateTitle : nil
    }
    
    /*func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        let day = self.lunarCalendar.component(.day, from: date)
        return self.lunarChars[day-1]
    }*/
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2099/12/31")!
    }
    
    /*func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var day: Int! = self.gregorian.component(.day, from: date)
        for i in num{
            if day == i{
            day = i
            print("all",day, num.count)
            }
        }
        //let a = day % 5 == 0 ? day/5 : 0;
        //print("dayyyyy", day)
        //let a = 3
        /*if a >= 2{
            a = 5
        }*/
        return day//day % 5 == 0 ? day/5 : 0;
    }*/
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        //var dateDot: Int = 0
        let day: Int! = self.gregorian.component(.day, from: date)
        //return [1,13,24,29].contains(day) ? UIImage(named: "icon_cat") : nil
        //return [1,13,24,29].contains(day) ? UIImage(named: "icon_cat") : nil
       /* for i in num {
            dateDot = i
        }*/
        let date = Date()
        //let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDate = dateFormatter.string(from: date)
        if a == false{
            a = true
            dateFormatter.dateFormat = "dd"
            saveDay = dateFormatter.string(from: date)
            print("aaabbbbbbbbb", saveDay,saveDate)
            
            dateFormatter.dateFormat = "MM"
            saveMonth = dateFormatter.string(from: date)
            print("aabbbbbbbbb", saveMonth)
            
            dateFormatter.dateFormat = "yyyy"
            saveYear = dateFormatter.string(from: date)
            print("aabbbbbbbbb", saveYear)
            /*print("dayyyy 11",calendar.component(.day, from: date))
            print("dayyyy 11",calendar.component(.month, from: date))
            print("dayyyy 11",calendar.component(.year, from: date))*/
        }
        let imageName = "line-29"
        switch num.count {
        case 1:
            return [num[0]].contains(day) ? UIImage(named: imageName) : nil
        case 2:
            return [num[0],num[1]].contains(day) ? UIImage(named: imageName) : nil
        case 3:
            return [num[0],num[1],num[2]].contains(day) ? UIImage(named: imageName) : nil
        case 4:
            return [num[0],num[1],num[2],num[3]].contains(day) ? UIImage(named: imageName) : nil
        case 5:
            return [num[0],num[1],num[2],num[3],num[4]].contains(day) ? UIImage(named: imageName) : nil
        case 6:
            return [num[0],num[1],num[2],num[3],num[4],num[5]].contains(day) ? UIImage(named: imageName) : nil
        case 7:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6]].contains(day) ? UIImage(named: imageName) : nil
        case 8:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7]].contains(day) ? UIImage(named: imageName) : nil
        case 9:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8]].contains(day) ? UIImage(named: imageName) : nil
        case 10:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9]].contains(day) ? UIImage(named: imageName) : nil
        case 11:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10]].contains(day) ? UIImage(named: imageName) : nil
        case 12:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11]].contains(day) ? UIImage(named: imageName) : nil
        case 13:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12]].contains(day) ? UIImage(named: imageName) : nil
        case 14:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13]].contains(day) ? UIImage(named: imageName) : nil
        case 15:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14]].contains(day) ? UIImage(named: imageName) : nil
        case 16:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15]].contains(day) ? UIImage(named: imageName) : nil
        case 17:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16]].contains(day) ? UIImage(named: imageName) : nil
        case 18:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17]].contains(day) ? UIImage(named: imageName) : nil
        case 19:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18]].contains(day) ? UIImage(named: imageName) : nil
        case 20:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19]].contains(day) ? UIImage(named: imageName) : nil
        case 21:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20]].contains(day) ? UIImage(named: imageName) : nil
        case 22:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21]].contains(day) ? UIImage(named: imageName) : nil
        case 23:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22]].contains(day) ? UIImage(named: imageName) : nil
        case 24:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23]].contains(day) ? UIImage(named: imageName) : nil
        case 25:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24]].contains(day) ? UIImage(named: imageName) : nil
        case 26:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25]].contains(day) ? UIImage(named: imageName) : nil
        case 27:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26]].contains(day) ? UIImage(named: imageName) : nil
        case 28:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27]].contains(day) ? UIImage(named: imageName) : nil
        case 29:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28]].contains(day) ? UIImage(named: imageName) : nil
        case 30:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28],num[29]].contains(day) ? UIImage(named: imageName) : nil
        case 31:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28],num[29],num[30]].contains(day) ? UIImage(named: imageName) : nil
        default:
            break
        }
        return nil
        //return [num[15]].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("change page to \(self.formatter.string(from: calendar.currentPage))")
        a = false
        startDate = self.formatter.string(from: calendar.currentPage)
        defaults.set(startDate, forKey: "defaultDate")
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM"
        let newDate = dateFormat.string(from: date)
        
        let oldDate = self.formatter.string(from: calendar.currentPage)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        
        let showDate = inputFormatter.date(from: oldDate)
        inputFormatter.dateFormat = "yyyy/MM"
        let resultString = inputFormatter.string(from: showDate!)
        print("*/*/*/*/*/*/",resultString)
        
         print("change",resultString , newDate)
        if resultString != newDate{
            nameArray = []
            tableData.reloadData()
        }else{
            loadDb()
        }
        fetchFromDb()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //print("calendar did select date \(self.formatter.string(from: date))")
        let oldDate = self.formatter.string(from: date)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        
        let showDate = inputFormatter.date(from: oldDate)!
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate)
        print("-----",resultString,showDate)
        calendar.select(showDate)
        compareDate = resultString
        //////// coredata

        calenderDate = []
        nameArray = []
        dateArray = []
        repArray = []
        hourArray = []
        minuteArray = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        let predicate = NSPredicate(format: "date == %@", resultString)
        fetchRequest.predicate = predicate
        
        do {
            calenderDate = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        
        for i in calenderDate{
            nameArray.append(i.value(forKey: "name") as! String)
            dateArray.append(i.value(forKey: "date") as! String)
            repArray.append(i.value(forKey: "repetition") as! Int)
            hourArray.append(i.value(forKey: "hour") as! Int)
            minuteArray.append(i.value(forKey: "minute") as! Int)
        }
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
       
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.tableData.reloadData()
        }
        //let myTimer : Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.myPerformeCode), userInfo: nil, repeats: false)
        //tableData.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if compareDate == ""{
            return "current" + saveDate
        }else{
            return "selected date " + compareDate
        }
    }*/
    //////table row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameArray.count > 0{
            print("table",calenderDate.count,nameArray.count,num.count)
            return nameArray.count
        }else{
            return 1
        }
    }
    
    ////// table cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("ssss",sum)
        if nameArray.count > 0{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewControllerCell
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewNibCell.ViewControllerCell, for: indexPath) as! ViewControllerCell
            //cell.textLabel?.text = nameArray[indexPath.row]
            //cell.detailTextLabel?.text = dateArray[indexPath.row]
            cell.lblCellDate.text = dateArray[indexPath.row]
            cell.lblCellExercise.text = nameArray[indexPath.row]
            cell.lblCellRep.text = String(repArray[indexPath.row])
            var zero = ""
            if minuteArray[indexPath.row] < 10 {
                zero = "0"
            }else{
                zero = ""
            }
            cell.lblCellTime.text = "0" + String(hourArray[indexPath.row]) + ":" + zero + String(minuteArray[indexPath.row])
            
            if repArray[indexPath.row] < 10 {
                zero = "0"
            }else{
                zero = ""
            }
            cell.lblCellRep.text = zero + String(repArray[indexPath.row])
            
            return cell
        }else if nameArray.count == 0{
            fetchFromDb()
            //return tableView.dequeueReusableCell(withIdentifier: TableViewNibCell.NothingFoundCell)!
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewNibCell.NothingFoundCell, for: indexPath) as! NothingFoundCell
            cell.lblNothing.text = "select a date to view your history"
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    ///////table delete data
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if compareDate == ""{
            let date = Date()
            //let calendar = Calendar.current
            let dateFormatter = DateFormatter()
        
            dateFormatter.dateFormat = "dd-MM-yyyy"
            compareDate = dateFormatter.string(from: date)
        }
        print("cal",saveDate,compareDate)
        
        if calenderDate.count > 0 && compareDate == saveDate{
            //print("true")
            return true
        }else{
            //print("false")
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("deleteee")
            //nameArray.remove(at: indexPath.row)
            //dateArray.remove(at: indexPath.row)
            //tableData.deleteRows(at: [indexPath], with: .automatic)
            nameArray.remove(at: indexPath.row)
            //tableData.deleteRows(at: [indexPath], with: .automatic)
            //tableData.reloadRows(at: [indexPath], with: .automatic)
            
            managedObjectContext?.delete(calenderDate[indexPath.row])
            do{
                try managedObjectContext?.save()
                tableData.reloadData()
                nameArray = []
                loadDb()
                //tableData.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                print(error)
            }
                        //tableData.reloadData()
        }
    }
}

