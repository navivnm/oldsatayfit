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
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    fileprivate var theme: Int = 0 {
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
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    fileprivate let datesWithCat = ["2015/05/05","2015/06/05","2015/07/05"]
    
    let lunarCalendar = NSCalendar(calendarIdentifier: .chinese)!
    let lunarChars = ["1","100","200"]
    
    ////////////////////////////////////
    
    
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var testDb = [NSManagedObject]()
    
    var num = [Int]()
    var countFlag = false
    var dateFlag = false
    var a = false
    var count: Int = 0
    var saveDate = String()
    var saveDay = String()
    var saveMonth = String()
    var saveYear = String()
    var startDate = String()
    var newDate = Date()
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //////////////////////calendar
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        //self.calendar.select(self.formatter.date(from: "2017/03/18")!)
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        ///////// bgcolor
        view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        //tbleViewHome.alpha = 0.7
        calendar.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        fetchFromDb()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func fetchFromDb(){
        //////////////////////
        num = []
        if startDate != "" {
            let dateString = startDate // change to your date format
            //print("new start", startDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            
            let dateee = dateFormatter.date(from: dateString)!
            print("new date",dateee)
            newDate = dateee
            
        }/*else{
            print("///notnull/////////",startDate)
        }*/
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        var startOfMonth = Calendar.current.date(from: comp)!
        print("start of month11", startOfMonth/*, comp.day!,*/ ,startOfMonth,comp.year!)
        
        if startDate != ""{
            startOfMonth = newDate
        }
        let startDateLocal = dateFormatter.string(from: startOfMonth)
        
        //print("start date \(startDateLocal,dateFormatter.string(from: startOfMonth))")
        
        if startDate != "" {
            //print("/////////656565",startDate)
        }
        
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
        }else{
            print("/////////else",startDate,startDateLocal,endDate)
        }
        
        //////////////////////////////////
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        dateFormatter.dateFormat = "dd"
        let b = dateFormatter.string(from: startOfMonth)
        print("bbbbbbbbb", b)
        let bb = dateFormatter.string(from: endOfMonth)
        print("endbbbbbbbbb", bb)
        
        dateFormatter.dateFormat = "MM"
        let c = dateFormatter.string(from: startOfMonth)
        print("bbbbbbbbb", c)
        
        dateFormatter.dateFormat = "yyyy"
        let d = dateFormatter.string(from: startOfMonth)
        print("bbbbbbbbb", d)
        
        let pred = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", b, bb, c, d)
        fetchRequest.predicate = pred
        
        do{
            testDb = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            print("count",testDb.count)
            
            for i in testDb {
                //print("name \(i.value(forKey: "name")!)")
                //print(i.value(forKey: "number")!)
                //print(i.value(forKey: "date")!)
                //print(i.value(forKey: "saveday")!)
                //print(i.value(forKey: "savemonth")!)
                //print(i.value(forKey: "saveyear")!)
                
                let a = i.value(forKey: "number")
                num.append(Int(a as! Int16))
                //print("aaaa",num.count)
            }
            for i in num {
                print("num", i)
            }
        }catch{
            print(error)
        }
        
       // [calendar.setNeedsDisplay()]
        calendar.reloadData()
        print("after load", startDate,endDate,num.count)
    }
    
    ///////////////////////////////calendar////////////////////////////////
    
    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        //return self.gregorian.isDateInToday(date) ? "今天" : nil
        return self.gregorian.isDateInToday(date) ? "N" : nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        let day = self.lunarCalendar.component(.day, from: date)
        return self.lunarChars[day-1]
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017/10/30")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day: Int! = self.gregorian.component(.day, from: date)
        var a = day % 5 == 0 ? day/5 : 0;
        //print("dayyyyy", a)
        if a >= 2{
            a = 1
        }
        return a//day % 5 == 0 ? day/5 : 0;
    }
    
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
        switch num.count {
        case 1:
            return [num[0]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 2:
            return [num[0],num[1]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 3:
            return [num[0],num[1],num[2]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 4:
            return [num[0],num[1],num[2],num[3]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 5:
            return [num[0],num[1],num[2],num[3],num[4]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 6:
            return [num[0],num[1],num[2],num[3],num[4],num[5]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 7:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 8:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 9:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 10:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 11:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 12:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 13:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 14:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 15:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 16:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 17:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 18:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 19:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 20:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 21:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 22:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 23:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 24:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 25:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 26:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 27:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 28:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 29:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 30:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28],num[29]].contains(day) ? UIImage(named: "icon_cat") : nil
        case 31:
            return [num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7],num[8],num[9],num[10],num[11],num[12],num[13],num[14],num[15],num[16],num[17],num[18],num[19],num[20],num[21],num[22],num[23],num[24],num[25],num[26],num[27],num[28],num[29],num[30]].contains(day) ? UIImage(named: "icon_cat") : nil
        default:
            break
        }
        return nil
        //return [num[15]].contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
        a = false
        startDate = self.formatter.string(from: calendar.currentPage)
        fetchFromDb()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    ///////////////////////////////////////////////////////////////////////
    
    @IBAction func btnSave(_ sender: Any) {
        print(txtName.text!)
        
        if (txtName.text?.characters.count)! > 0{
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            //let year =  components.year
            //let month = components.month
            let day = components.day
            
            //print(year!)
            //print(month!)
            print(day!)
            print("hiiii")
            
            if countFlag == false{
                count = testDb.count + 1
                countFlag = true
            }else{
                count = count+1
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "Test", in: managedObjectContext!)
            let object = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            object.setValue(txtName.text, forKey: "name")
            object.setValue(day, forKey: "number")
            object.setValue(saveDate, forKey: "date")
            object.setValue(saveDay, forKey: "saveday")
            object.setValue(saveMonth, forKey: "savemonth")
            object.setValue(saveYear, forKey: "saveyear")

            print(count)
            do{
                try managedObjectContext?.save()
            }catch{
                print("save errorrr",error)
            }
        }else{
            for i in num {
                print("lll",i)
            }
        }
        calendar.reloadData()
        //fetchFromDb()
    }

    @IBAction func btnLoad(_ sender: Any) {
        num = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        
        do{
            testDb = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
            for i in testDb {
                //print(i.value(forKey: "name")!)
                print(i.value(forKey: "number")!)
                let a = i.value(forKey: "number")
                num.append(Int(a as! Int16))
                print("number to be saved",a!)
            }
        }catch{
            print("fetch error",error)
        }
    }
}

