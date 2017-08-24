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
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    ////////////////////////////////////
    
    
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var testDb = [NSManagedObject]()
    var calenderDate = [NSManagedObject]()
    var num = [Int]()
    
    var nameArray = [String]()
    var dateArray = [String]()
    var repArray = [Int]()
    var hourArray = [Int]()
    var minuteArray = [Int]()

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
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        defaults.set("", forKey: "defaultDate")
        var cellNib = UINib(nibName: TableViewNibCell.ViewControllerCell, bundle: nil)
        tableData.register(cellNib, forCellReuseIdentifier: TableViewNibCell.ViewControllerCell)
        
        cellNib = UINib(nibName: TableViewNibCell.NothingFoundCell, bundle: nil)
        tableData.register(cellNib, forCellReuseIdentifier: TableViewNibCell.NothingFoundCell)
        
        //////////////////////calendar
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        ///////// bgcolor
        tableData.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        tableData.rowHeight = 80
    }

    override func viewWillAppear(_ animated: Bool) {
        stopDB = false
        compareDate = ""
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
            }else{
                startDate = defaultdate
            }
        }
        
        if startDate != "" {
            let dateString = startDate // change to your date format
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let dateee = dateFormatter.date(from: dateString)!
            
            newDate = dateee
        }
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        var startOfMonth = Calendar.current.date(from: comp)!
        let startDateLocal = dateFormatter.string(from: startOfMonth)
        
        if startDate != ""{
            startOfMonth = newDate
        }
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)!

        if startDate == ""{
            startDate = startDateLocal
        }
        
        //////////////////////////////////
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        dateFormatter.dateFormat = "dd"
        let b = dateFormatter.string(from: startOfMonth)

        let bb = dateFormatter.string(from: endOfMonth)
        
        dateFormatter.dateFormat = "MM"
        let c = dateFormatter.string(from: startOfMonth)
        
        dateFormatter.dateFormat = "yyyy"
        let d = dateFormatter.string(from: startOfMonth)
        
        let pred = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", b, bb, c, d)
        fetchRequest.predicate = pred
        
        do{
            testDb = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            
            for i in testDb {
                let a = i.value(forKey: "number")
                num.append(Int(a as! Int16))
            }
            
            //////remove duplicate values from array
            
            num = Array(Set(num))
        }catch{
            //print(error)
        }
        startDate = ""
        calendar.reloadData()
    }
    
    func loadDb(){
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
            //print(error)
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
    }
    
    ///////////////////////////////calendar////////////////////////////////
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        
        //////////// coredata
        if stopDB == false {
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
                //print(error)
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
        }
        return self.gregorian.isDateInToday(date) ? dateTitle : nil
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2099/12/31")!
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let day: Int! = self.gregorian.component(.day, from: date)
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        saveDate = dateFormatter.string(from: date)
        if a == false{
            a = true
            dateFormatter.dateFormat = "dd"
            saveDay = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "MM"
            saveMonth = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "yyyy"
            saveYear = dateFormatter.string(from: date)
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
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
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

        if resultString != newDate{
            nameArray = []
            tableData.reloadData()
        }else{
            loadDb()
        }
        fetchFromDb()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let oldDate = self.formatter.string(from: date)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy/MM/dd"
        
        let showDate = inputFormatter.date(from: oldDate)!
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let resultString = inputFormatter.string(from: showDate)
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
            //print(error)
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
    
    //////table row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameArray.count > 0{
            return nameArray.count
        }else{
            return 1
        }
    }
    
    ////// table cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if nameArray.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewNibCell.ViewControllerCell, for: indexPath) as! ViewControllerCell
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
            let dateFormatter = DateFormatter()
        
            dateFormatter.dateFormat = "dd-MM-yyyy"
            compareDate = dateFormatter.string(from: date)
        }
        
        if calenderDate.count > 0 && compareDate == saveDate{
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            nameArray.remove(at: indexPath.row)
            managedObjectContext?.delete(calenderDate[indexPath.row])
            do{
                try managedObjectContext?.save()
                tableData.reloadData()
                nameArray = []
                loadDb()
            }catch{
                //print(error)
            }
        }
    }
}

