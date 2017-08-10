//
//  HomeViewController.swift
//  abcd
//
//  Created by Naveen Vijay on 06/04/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,UITextFieldDelegate {

    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)? .persistentContainer.viewContext
    
    @IBOutlet weak var tbleViewHome: UITableView!
    
    @IBOutlet weak var txtExerciseName: UITextField!
    @IBOutlet weak var txtExerciseRep: UITextField!
    @IBOutlet weak var txtHour: UITextField!
    @IBOutlet weak var txtMinute: UITextField!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var lblTodayInfo: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    
    @IBOutlet weak var buttonToday: UIButton!
    @IBOutlet weak var btnSetInfo: UIButton!
    
    @IBOutlet weak var viewToday: UIView!
    
    @IBOutlet weak var btnClose: UIBarButtonItem!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnAddToday: UIBarButtonItem!
    
    var dataArray = [NSManagedObject]()
    var nameArray = [String]()
    var dateArray = [String]()
    var repArray = [Int]()
    var hourArray = [Int]()
    var minuteArray = [Int]()
    var fetchArray = [NSManagedObject]()

    var minuteMax = Int()
    var hourMax = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboard()
        
        self.btnClose.isEnabled = false
        self.btnClose.tintColor = .clear
        self.btnSave.isEnabled = false
        self.btnSave.tintColor = .clear
        
        self.txtExerciseName.delegate = self
        self.txtHour.delegate = self
        self.txtMinute.delegate = self
        self.txtExerciseRep.delegate = self
        
        var cellNib = UINib(nibName: tableNib.NothingFound, bundle: nil)
        tbleViewHome.register(cellNib, forCellReuseIdentifier: tableNib.NothingFound)
        
        cellNib = UINib(nibName: tableNib.ViewControllerCell, bundle: nil)
        tbleViewHome.register(cellNib, forCellReuseIdentifier: tableNib.ViewControllerCell)

        lblTodayInfo.isHidden = true
        viewToday.isHidden = true
        viewToday.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        tbleViewHome.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        tbleViewHome.rowHeight = 80
        
        title = "Home"
    }
    
    struct tableNib {
        static let ViewControllerCell = "ViewControllerCell"
        static let NothingFound = "NothingFoundCell"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        return true
    }
    
    func loadDb(){
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let saveDate = dateFormatter.string(from: date)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
        let predicate = NSPredicate(format: "date == %@", saveDate)
        fetchRequest.predicate = predicate
        
        do{
            dataArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
        }catch{
            //print(error)
        }
        
        for i in dataArray{
            nameArray.append(i.value(forKey: "name") as! String)
            dateArray.append(i.value(forKey: "date") as! String)
            repArray.append(i.value(forKey: "repetition") as! Int)
            hourArray.append(i.value(forKey: "hour") as! Int)
            minuteArray.append(i.value(forKey: "minute") as! Int)
        }
        tbleViewHome.reloadData()
        hourMax = hourArray.reduce(0, +)
        minuteMax = minuteArray.reduce(0, +)
    }
    
    func callGraphData(){
        graphData(valueDate: -30)
        graphData(valueDate: -15)
        graphData(valueDate: -7)
    }
    
    func graphData(valueDate: Int){
        var hourArray = [Int]()
        var minuteArray = [Int]()
        let history = valueDate
        
        let calendar = NSCalendar.current
        let now = NSDate()
        let sevenDaysAgo = calendar.date(byAdding: .day, value: history, to: now as Date)!

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-YYYY"
        
        ///days before
        dateFormat.dateFormat = "dd"
        let dd = dateFormat.string(from: sevenDaysAgo)
        
        dateFormat.dateFormat = "MM"
        let mm = dateFormat.string(from: sevenDaysAgo)
        
        dateFormat.dateFormat = "YYYY"
        let yyyy = dateFormat.string(from: sevenDaysAgo)
        
        ///////today/////////
        dateFormat.dateFormat = "dd"
        let ddToday = dateFormat.string(from: now as Date)
        
        dateFormat.dateFormat = "MM"
        let mmToday = dateFormat.string(from: now as Date)
        
        dateFormat.dateFormat = "YYYY"
        let yyyyToday = dateFormat.string(from: now as Date)
        
        if mm != mmToday{
                let m = Int(mm)
                let y = Int(yyyy)
                
                let dateComponents = DateComponents(year: y, month: m)
                let calendar = Calendar.current
                let date = calendar.date(from: dateComponents)!
                
                let range = calendar.range(of: .day, in: .month, for: date)!
                let temp = range.count
                let numDays = String(temp)
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
                let predicate = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@ ", dd, numDays, mm, yyyy)
                fetchRequest.predicate = predicate
                do{
                    fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
                    for i in fetchArray {
                        hourArray.append(i.value(forKey: "hour") as! Int)
                        minuteArray.append(i.value(forKey: "minute") as! Int)
                    }
                }catch{
                    //print(error)
                }
                
                let predicateTwo = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", "01", ddToday, mmToday, yyyyToday)
                fetchRequest.predicate = predicateTwo
                
                do{
                    fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
                    for i in fetchArray {
                        hourArray.append(i.value(forKey: "hour") as! Int)
                        minuteArray.append(i.value(forKey: "minute") as! Int)
                    }
                    let sumHour = hourArray.reduce(0, +)
                    let sumMinute = minuteArray.reduce(0, +)
                    let temp = sumMinute % 60
                    let temp2 = (sumMinute - temp) / 60
                    let totalHour = sumHour + temp2
                    var zero = ""
                    if temp < 10 {
                        zero = "0"
                    }else{
                        zero = ""
                    }
                    switch history {
                        case -30:
                            lblMonth.text = String(totalHour) + " : " + zero + String(temp)
                        case -15:
                            lblWeek.text = String(totalHour) + " : " + zero + String(temp)
                        case -7:
                            lblDay.text = String(totalHour) + " : " + zero + String(temp)
                        default:
                            break
                        }
                }catch{
                    //print(error)
                }
        }else{
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
            let predicate = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", dd, ddToday, mm, yyyy)
            fetchRequest.predicate = predicate
            do{
                fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]

                for i in fetchArray {
                    hourArray.append(i.value(forKey: "hour") as! Int)
                    minuteArray.append(i.value(forKey: "minute") as! Int)
                }
                
                let sumHour = hourArray.reduce(0, +)
                let sumMinute = minuteArray.reduce(0, +)
                let temp = sumMinute % 60
                let temp2 = (sumMinute - temp) / 60
                let totalHour = sumHour + temp2
                
                var zero = ""
                if temp < 10 {
                    zero = "0"
                }else{
                    zero = ""
                }
                
                switch history {
                case -30:
                    lblMonth.text = String(totalHour) + " : " + zero + String(temp)
                case -15:
                    lblWeek.text = String(totalHour) + " : " + zero + String(temp)
                case -7:
                    lblDay.text = String(totalHour) + " : " + zero + String(temp)
                default:
                    break
                }
            }catch{
                //print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameArray = []
        dateArray = []
        repArray = []
        hourArray = []
        minuteArray = []
        loadDb()
        callGraphData()
        tbleViewHome.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // textfield func for the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtExerciseName.resignFirstResponder()
        txtExerciseRep.resignFirstResponder()
        txtHour.resignFirstResponder()
        txtMinute.resignFirstResponder()
        return true
    }
    
    @IBAction func btnSets(_ sender: Any) {
        if !lblTodayInfo.isHidden {
            lblTodayInfo.isHidden = true
            btnSetInfo.tintColor = UIColor.black
            txtExerciseName.isEnabled = true
            txtExerciseRep.isEnabled = true
            txtHour.isEnabled = true
            txtMinute.isEnabled = true
        }else{
            lblTodayInfo.isHidden = false
            btnSetInfo.tintColor = UIColor.red
            txtExerciseName.isEnabled = false
            txtExerciseRep.isEnabled = false
            txtHour.isEnabled = false
            txtMinute.isEnabled = false
        }
    }
    
    /////////btn show/hide view
    @IBAction func addToday(_ sender: Any) {
        title = "Today"
        self.btnClose.isEnabled = true
        self.btnClose.tintColor = UIColor.black
        self.btnSave.isEnabled = true
        self.btnSave.tintColor = .black
        self.btnAddToday.isEnabled = false
        self.btnAddToday.tintColor = .clear
        if viewToday.isHidden == true {
            viewToday.isHidden = false
        }else{
            viewToday.isHidden = true
        }
    }
    
    @IBAction func addTodayView(_ sender: Any) {
        title = "Today"
        self.btnClose.isEnabled = true
        self.btnClose.tintColor = UIColor.black
        self.btnSave.isEnabled = true
        self.btnSave.tintColor = .black
        self.btnAddToday.isEnabled = false
        self.btnAddToday.tintColor = .clear
        if viewToday.isHidden == true {
            viewToday.isHidden = false
        }else{
            viewToday.isHidden = true
        }
    }
    
    @IBAction func btnRemoveToday(_ sender: Any) {
        if btnSetInfo.tintColor == UIColor.red{
            txtExerciseName.isEnabled = true
            txtExerciseRep.isEnabled = true
            txtHour.isEnabled = true
            txtMinute.isEnabled = true
            btnSetInfo.tintColor = UIColor.black
        }
        
        title = "Home"
        txtExerciseName.resignFirstResponder()
        txtExerciseRep.resignFirstResponder()
        txtHour.resignFirstResponder()
        txtMinute.resignFirstResponder()
        
        dataArray = []
        nameArray = []
        dateArray = []
        repArray = []
        hourArray = []
        minuteArray = []
        
        loadDb()
        callGraphData()
        
        self.btnClose.isEnabled = false
        self.btnClose.tintColor = .clear
        
        self.btnSave.isEnabled = false
        self.btnSave.tintColor = .clear
        
        self.btnAddToday.isEnabled = true
        self.btnAddToday.tintColor = .black
        
        viewToday.isHidden = true
        txtExerciseName.text = ""
        txtExerciseRep.text = ""
        txtHour.text = ""
        txtMinute.text = ""
        lblTodayInfo.isHidden = true
    }
    

    ////////////////////////////save to coredata///////////////////////////////////////////
    
    @IBAction func btnSave(_ sender: Any) {
        if !(txtExerciseName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            
            if let test = Int((txtHour.text?.trimmingCharacters(in: .whitespaces))!){
                //print("test", test)
                txtHour.text = String(test)
            }else{
                //print("null")
                txtHour.text = "0"
            }
            
            //if (Int(txtHour.text!) == nil){
              //  txtHour.text = "0"
            //}
            
            if let hour = Int(txtHour.text!){
                if hour >= 0 && hour < 4{
                    
                    if hour >= 1 && txtMinute.text == ""{
                        txtMinute.text = "0"
                    }else{
                        if let a = Int(txtMinute.text!){
                            if hour <= 0 && a <= 0 {
                                alertView(title: "ooops!", message: "add minute 1-59")
                                return
                            }
                        }
                    }
                    
                    if let minute = Int((txtMinute.text?.trimmingCharacters(in: .whitespaces))!){//Int(txtMinute.text!){
                        txtMinute.text = String(minute)
                        if minute >= 0 && minute < 60{
                            var exerRep = Int()
                            if let temp = Int((txtExerciseRep.text?.trimmingCharacters(in: .whitespaces))!){//Int(txtExerciseRep.text!){
                                if temp >= 0 && temp < 100 {
                                    exerRep = temp
                                }else{
                                    alertView(title: "ooops!", message: "add repeat less than 100")
                                    return
                                }
                            }else{
                                exerRep = 0
                            }
                            
                            let tempHour = hourMax + hour
                            let tempMinute = minuteMax + minute
                            let temp = tempMinute % 60
                            let totHour = (tempMinute - temp) / 60
                            let temp1 = tempHour + totHour
                            if temp1 >= 3{
                                let titleString = String(temp1) + " hour & " + String(temp) + " minute! "
                                alertView(title: titleString, message: "Don't do too much exercise. Do less than 3 hours a day.. Take rest and comback tomorrow")
                                return
                            }else{
                                hourMax = temp1//tempHour + totHour
                                minuteMax = temp
                            }
                            
                            let datee = Date()
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.year, .month, .day], from: datee)
                            
                            let day = components.day
                            
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let saveDate = dateFormatter.string(from: date)
                            
                            dateFormatter.dateFormat = "dd"
                            let saveDay = dateFormatter.string(from: date)
                            
                            dateFormatter.dateFormat = "MM"
                            let saveMonth = dateFormatter.string(from: date)
                            
                            dateFormatter.dateFormat = "yyyy"
                            let saveYear = dateFormatter.string(from: date)
                            
                            let entity = NSEntityDescription.entity(forEntityName: "Test", in: managedObjectContext!)
                            let object = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                            object.setValue(txtExerciseName.text, forKey: "name")
                            object.setValue(saveDate, forKey: "date")
                            object.setValue(exerRep, forKey: "repetition")
                            object.setValue(hour, forKey: "hour")
                            object.setValue(minute, forKey: "minute")
                            object.setValue(day, forKey: "number")
                            object.setValue(saveDay, forKey: "saveday")
                            object.setValue(saveMonth, forKey: "savemonth")
                            object.setValue(saveYear, forKey: "saveyear")
                            
                            do{
                                try managedObjectContext?.save()
                                lblHealth.text = "SAVED"
                                lblHealth.textColor = .white
                                btnSave.isEnabled = false
                                let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    //code with delay
                                    self.lblHealth.text = "Health Is Wealth"
                                    self.lblHealth.textColor = .black
                                    self.btnSave.isEnabled = true
                                }
                                txtExerciseName.resignFirstResponder()
                                txtHour.resignFirstResponder()
                                txtMinute.resignFirstResponder()
                            }catch{
                                //print("save errorrr",error)
                            }
                        } else{
                            alertView(title: "ooops!", message: "add minute 1-59")
                        }
                    } else{
                        alertView(title: "ooops!", message: "add minute")
                        txtMinute.text = ""
                    }
                }else{
                    alertView(title: "ooops!", message: "add hour 1 - 3")
                }
            }else{
                alertView(title: "ooops!", message: "add hour")
            }
        }else{
            alertView(title: "ooops!", message: "add exercise name")
        }
    }
    
    func alertView(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameArray.count != 0{
            return nameArray.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if nameArray.count != 0{
            buttonToday.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: tableNib.ViewControllerCell, for: indexPath) as! ViewControllerCell
            cell.lblCellExercise.text = nameArray[indexPath.row]
            cell.lblCellDate.text = dateArray[indexPath.row]
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
            buttonToday.isHidden = false
            let cell = tableView.dequeueReusableCell(withIdentifier: tableNib.NothingFound, for: indexPath) as! NothingFoundCell
            cell.lblNothing.text = "did u exercise today? then add it"
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            nameArray.remove(at: indexPath.row)
            
            managedObjectContext?.delete(dataArray[indexPath.row])
            do{
                try managedObjectContext?.save()
                tbleViewHome.reloadData()
                nameArray = []
                dateArray = []
                repArray = []
                hourArray = []
                minuteArray = []
                
                loadDb()
                callGraphData()
            }catch{
                //print("delete errpr",error)
            }
        }
    }
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
