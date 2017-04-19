//
//  HomeViewController.swift
//  abcd
//
//  Created by Naveen Vijay on 06/04/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    let circleLayer = CAShapeLayer()
    let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)? .persistentContainer.viewContext
    
    @IBOutlet weak var tbleViewHome: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var buttonToday: UIButton!
    @IBOutlet weak var viewToday: UIView!
    
    var dataArray = [NSManagedObject]()
    var nameArray = [String]()
    var dateArray = [String]()
    var a = [1,2,3,4,5,2,4,1,4,3,6,5]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Remove duplicates:
        // first by converting to a Set
        // and then back to Array
        a = Array(Set(a))
        
        print("aaaaaaaa",a)
        let cellNib = UINib(nibName: tableNib.NothingFound, bundle: nil)
        tbleViewHome.register(cellNib, forCellReuseIdentifier: tableNib.NothingFound)
        
        //loadDb()
        viewToday.isHidden = true
        view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        tbleViewHome.alpha = 0.7
        tbleViewHome.rowHeight = 80
        //tbleViewHome.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
        print("loadddddd")
        /////////// create circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(40), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
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
        
        /////////tab bar text color
        let unselectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let selectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
    }
    
    struct tableNib {
        static let NothingFound = "NothingFoundCell"
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
        }
        tbleViewHome.reloadData()
    }
    
    /*func addCircleView() {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        let circleWidth = CGFloat(200)
        let circleHeight = circleWidth
        
        // Create a new CircleView
        //let circleView = CircleView(frame: CGRect(x: diceRoll, y: 0, width: circleWidth, height: circleHeight))
        let circleView = circle(frame: CGRect(x: diceRoll, y: 0, width: circleWidth, height: circleHeight))
        //let test = CircleView(frame: CGRect(x: diceRoll, y: 0, width: circleWidth, height: circleHeight))
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 1.0)
    }*/
    override func viewWillAppear(_ animated: Bool) {
        print("home")
        nameArray = []
        loadDb()
        tbleViewHome.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////////btn show/hide view
    @IBAction func addToday(_ sender: Any) {
        if viewToday.isHidden == true {
            viewToday.isHidden = false
        }else{
            viewToday.isHidden = true
        }
    }
    
    
    @IBAction func removeToday(_ sender: Any) {
        dataArray = []
        nameArray = []
        loadDb()
        viewToday.isHidden = true
    }
    ////////////////////////////save to coredata///////////////////////////////////////////
    
    @IBAction func buttonSave(_ sender: Any) {
        print(txtName.text!)
        
        if (txtName.text?.characters.count)! > 0{
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
            
            /*print("dayyyy 11",calendar.component(.day, from: date))
             print("dayyyy 11",calendar.component(.month, from: date))
             print("dayyyy 11",calendar.component(.year, from: date))*/
            /*if countFlag == false{
             count = testDb.count + 1
             countFlag = true
             }else{
             count = count+1
             }*/
            
            let entity = NSEntityDescription.entity(forEntityName: "Test", in: managedObjectContext!)
            let object = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            object.setValue(txtName.text, forKey: "name")
            object.setValue(day, forKey: "number")
            object.setValue(saveDate, forKey: "date")
            object.setValue(saveDay, forKey: "saveday")
            object.setValue(saveMonth, forKey: "savemonth")
            object.setValue(saveYear, forKey: "saveyear")
            
            //print(count)
            do{
                try managedObjectContext?.save()
            }catch{
                print("save errorrr",error)
            }
        }/*else{
         for i in num {
         print("lll",i)
         }
         }*/
        //calendar.reloadData()
        //fetchFromDb()
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

extension HomeViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today's Summery"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameArray.count != 0{
            return nameArray.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if nameArray.count != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = nameArray[indexPath.row]
            cell.detailTextLabel?.text = dateArray[indexPath.row]
            return cell
        }else if nameArray.count == 0{
            return tableView.dequeueReusableCell(withIdentifier: tableNib.NothingFound,for: indexPath)
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
                loadDb()
            }catch{
                print("delete errpr",error)
            }
            print("ok")
        }
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


