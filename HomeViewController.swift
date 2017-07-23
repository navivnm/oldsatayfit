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

    //let circleLayer = CAShapeLayer()
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)? .persistentContainer.viewContext
    
    @IBOutlet weak var tbleViewHome: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
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
        /*let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)*/
        // Remove duplicates:
        // first by converting to a Set
        // and then back to Array
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "exercise.jpg")!)
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
        
        //loadDb()
        lblTodayInfo.isHidden = true
        viewToday.isHidden = true
        viewToday.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        //view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        tbleViewHome.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        tbleViewHome.rowHeight = 80
        print("loadddddd")
        
        /////////// create circle
        /*let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(40), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        imgUser.layer.cornerRadius = 14.5
        imgUser.clipsToBounds = true
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.white.cgColor//(red: 150/255, green: 245/255, blue: 255/255, alpha: 1.0).cgColor//UIColor.white.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)
        */
        title = "Home"
        viewToday.backgroundColor = UIColor(patternImage: UIImage(named: "viewbg")!)
        /////////tab bar text color
        //let unselectedColor   = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        //let selectedColor = UIColor(red: 255/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
    }
    
    struct tableNib {
        static let ViewControllerCell = "ViewControllerCell"
        static let NothingFound = "NothingFoundCell"
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // I added this line
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
            print(error)
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
        print("new hr",hourMax,minuteMax)
        //graphData()
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
        let startDate = calendar.startOfDay(for: sevenDaysAgo)
        
        print("hhhhhhhistory",history,startDate)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-YYYY"
        //let sevenDay = dateFormat.string(from: sevenDaysAgo)
        //let today = dateFormat.string(from: now as Date)
        
        ///days before
        dateFormat.dateFormat = "dd"
        let dd = dateFormat.string(from: sevenDaysAgo)
        
        dateFormat.dateFormat = "MM"
        let mm = dateFormat.string(from: sevenDaysAgo)
        
        dateFormat.dateFormat = "YYYY"
        let yyyy = dateFormat.string(from: sevenDaysAgo)
        
        print("yesterday",dd,mm,yyyy)
        
        ///////today/////////
        dateFormat.dateFormat = "dd"
        let ddToday = dateFormat.string(from: now as Date)
        
        dateFormat.dateFormat = "MM"
        let mmToday = dateFormat.string(from: now as Date)
        
        dateFormat.dateFormat = "YYYY"
        let yyyyToday = dateFormat.string(from: now as Date)
        
        print("today", ddToday,mmToday,yyyyToday)
        
        if mm != mmToday{
            /*if yyyy != yyyyToday{
                print("month not y not")
            }else{*/
                print("month not y yes")
                let m = Int(mm)
                let y = Int(yyyy)
                
                let dateComponents = DateComponents(year: y, month: m)
                let calendar = Calendar.current
                let date = calendar.date(from: dateComponents)!
                
                let range = calendar.range(of: .day, in: .month, for: date)!
                let temp = range.count
                let numDays = String(temp)
                print("days in month",numDays)
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
                let predicate = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@ ", dd, numDays, mm, yyyy)
                fetchRequest.predicate = predicate
                do{
                    fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
                    for i in fetchArray {
                        //print(i.value(forKey: "name") as! String)
                        hourArray.append(i.value(forKey: "hour") as! Int)
                        minuteArray.append(i.value(forKey: "minute") as! Int)
                    }
                }catch{
                    print(error)
                }
                
                let predicateTwo = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", "01", ddToday, mmToday, yyyyToday)
                fetchRequest.predicate = predicateTwo
                
                do{
                    //try fetchArray.append(managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject])
                    fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
                    for i in fetchArray {
                        //print(i.value(forKey: "name") as! String)
                        hourArray.append(i.value(forKey: "hour") as! Int)
                        minuteArray.append(i.value(forKey: "minute") as! Int)
                    }
                    let sumHour = hourArray.reduce(0, +)
                    let sumMinute = minuteArray.reduce(0, +)
                    let temp = sumMinute % 60
                    let temp2 = (sumMinute - temp) / 60
                    let totalHour = sumHour + temp2
                    print("sum", sumHour,totalHour, temp)
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
                    print(error)
                }
            //}
        }else{
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Test")
            let predicate = NSPredicate(format: "((saveday >= %@) && (saveday <= %@)) && savemonth == %@ && saveyear == %@", dd, ddToday, mm, yyyy)
            fetchRequest.predicate = predicate
            do{
                fetchArray = try managedObjectContext?.fetch(fetchRequest) as! [NSManagedObject]
                print("fetchdbcount",fetchArray.count)
                
                for i in fetchArray {
                    hourArray.append(i.value(forKey: "hour") as! Int)
                    minuteArray.append(i.value(forKey: "minute") as! Int)
                }
                
                let sumHour = hourArray.reduce(0, +)
                let sumMinute = minuteArray.reduce(0, +)
                let temp = sumMinute % 60
                let temp2 = (sumMinute - temp) / 60
                let totalHour = sumHour + temp2
                print("sum", sumHour,totalHour, temp)
                
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
                print(error)
            }
        }
        /*for i in aa {
            aaName.append(i.value(forKey: "name") as! String)
        }
        for i in aaName {
            print("i",i)
        }
        print(aaName.count)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("home")
        nameArray = []
        dateArray = []
        repArray = []
        hourArray = []
        minuteArray = []
        loadDb()
        //graphData()
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
        //print("haii")
        title = "Today"
        self.btnClose.isEnabled = true
        self.btnClose.tintColor = UIColor.black
        self.btnSave.isEnabled = true
        self.btnSave.tintColor = .black
        self.btnAddToday.isEnabled = false
        self.btnAddToday.tintColor = .clear
        //lblDay.center.x = lblWeek.center.x
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
        //lblDay.center.x = lblWeek.center.x
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
        print("hhmm",hourMax,minuteMax)
        
        if !(txtExerciseName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            if (Int(txtHour.text!) == nil){
                print("no int val")
                txtHour.text = "0"
            }
            
            if let hour = Int(txtHour.text!){
                if hour >= 0 && hour < 4{
                    
                    if hour >= 1 && txtMinute.text == ""{
                        txtMinute.text = "0"
                    }else{
                        if let a = Int(txtMinute.text!){
                            if hour <= 0 && a <= 0 {
                                //alertView(message: "enter minute 0-59")
                                alertView(title: "ooops!", message: "add minute 0-59")
                                return
                            }
                        }
                    }
                    
                    if let minute = Int(txtMinute.text!){
                        /*var minute = Int()
                         if (Int(txtMinute.text!) == nil) && hour >= 1{
                         minute = 0
                         }else{
                         let a = txtMinute.text
                         minute = Int(a!)!
                         }*/
                        if minute >= 0 && minute < 60{
                            var exerRep = Int()
                            if let temp = Int(txtExerciseRep.text!){
                                if temp >= 0 && temp < 100 {
                                    exerRep = temp
                                }else{
                                    //alertView(message: "not in range")
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
                            //minuteMax = temp
                            print("hhmm", temp1,temp)
                            if temp1 >= 4{
                                let titleString = String(temp1) + " hour & " + String(temp) + " minute! "
                                //alertView(message: "Don't do too much exercise. Do less than 4 hours a day")
                                alertView(title: titleString, message: "Don't do too much exercise. Do less than 4 hours a day.. Take rest and comback tomorrow")
                                return
                            }else{
                                hourMax = temp1//tempHour + totHour
                                minuteMax = temp
                            }
                            
                            let datee = Date()
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.year, .month, .day], from: datee)
                            
                            //let year =  components.year
                            //let month = components.month
                            let day = components.day
                            
                            //print(year!)
                            //print(month!)
                            print(day!)
                            print("hiiii")
                            
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let saveDate = dateFormatter.string(from: date)
                            
                            dateFormatter.dateFormat = "dd"
                            let saveDay = dateFormatter.string(from: date)
                            print("aaabbbbbbbbb", saveDay,saveDate)
                            
                            dateFormatter.dateFormat = "MM"
                            let saveMonth = dateFormatter.string(from: date)
                            print("aabbbbbbbbb", saveMonth)
                            
                            dateFormatter.dateFormat = "yyyy"
                            let saveYear = dateFormatter.string(from: date)
                            print("aabbbbbbbbb", saveYear)
                            
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
                            
                            //print(count)
                            do{
                                try managedObjectContext?.save()
                                lblHealth.text = "SAVED"
                                lblHealth.textColor = .white
                                btnSave.isEnabled = false
                                let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    // Your code with delay
                                    self.lblHealth.text = "Health Is Wealth"
                                    self.lblHealth.textColor = .black
                                    self.btnSave.isEnabled = true
                                    //self.loadDb()
                                }
                                txtExerciseName.resignFirstResponder()
                                txtHour.resignFirstResponder()
                                txtMinute.resignFirstResponder()
                            }catch{
                                print("save errorrr",error)
                            }
                        } else{
                            //print("minutee",txtMinute.text!)
                            //alertView(message: "enter minute 0-59")
                            alertView(title: "ooops!", message: "add minute 0-59")
                        }
                    } else{
                        //alertView(message: "add minute")
                        alertView(title: "ooops!", message: "add minute")
                    }
                }else{
                    //print("hour")
                    //alertView(message: "enter hour 1-3")
                    alertView(title: "ooops!", message: "add hour 1 - 3")
                }
            }else{
                //txtHour.text = "0"
                //alertView(message: "add hour")
                alertView(title: "ooops!", message: "add hour")
            }
        }else{
            alertView(title: "ooops!", message: "add exercise name")
            //alertView(message: "enter exercise name")
        }
        //calendar.reloadData()
        //fetchFromDb()
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

  //  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //    return "Today's Summery"
    //}
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        // Do your customization
        view.backgroundColor = UIColor.red
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 20))
        view.addSubview(label)
        label.text = "exercise"
        
        let label2 = UILabel(frame: CGRect(x: 180, y: 0, width: 100, height: 20))
        view.addSubview(label2)
        label2.text = "set/reps"
        
        let label3 = UILabel(frame: CGRect(x: 280, y: 0, width: 100, height: 20))
        view.addSubview(label3)
        label3.text = "time"
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }*/
    
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
            cell.lblCellRep.text = String(repArray[indexPath.row])
            var zero = ""
            if minuteArray[indexPath.row] < 10 {
                zero = "0"
            }else{
                zero = ""
            }
            cell.lblCellTime.text = "0" + String(hourArray[indexPath.row]) + ":" + zero + String(minuteArray[indexPath.row])
            return cell
        }else if nameArray.count == 0{
            //return tableView.dequeueReusableCell(withIdentifier: tableNib.NothingFound,for: indexPath)
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
            //tbleViewHome.reloadRows(at: [indexPath], with: .automatic)
            
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
                print("delete errpr",error)
            }
            print("ok")
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
