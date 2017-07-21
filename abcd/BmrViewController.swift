//
//  BmrViewController.swift
//  abcd
//
//  Created by Naveen Vijay on 27/04/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit

class BmrViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtHeightCm: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtFeet: UITextField!
    @IBOutlet weak var txtInches: UITextField!
    
    @IBOutlet weak var lblBmr: UILabel!
    @IBOutlet weak var lblLbs: UILabel!
    @IBOutlet weak var lblKgCm: UILabel!
    
    @IBOutlet weak var lblMaintain: UILabel!
    @IBOutlet weak var lblHalf: UILabel!
    @IBOutlet weak var lblFull: UILabel!
    @IBOutlet weak var lblHalfPlus: UILabel!
    @IBOutlet weak var lblFullPlus: UILabel!
    
    @IBOutlet weak var switchMF: UISwitch!
    @IBOutlet weak var switchKGLBS: UISwitch!
    
    @IBOutlet weak var txtViewInfo: UITextView!
    
    @IBOutlet weak var imgSex: UIImageView!
    
    @IBOutlet weak var segmentDRI: UISegmentedControl!
    
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var barTitle: UINavigationItem!
    @IBOutlet weak var btnClose: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewInfo.isHidden = true
        hideKeyboard()
        //view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        btnClose.isEnabled = false
        btnClose.tintColor = .clear
        
        self.txtAge.delegate = self
        self.txtWeight.delegate = self
        self.txtHeightCm.delegate = self
        self.txtFeet.delegate = self
        self.txtInches.delegate = self
        
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
        txtHeightCm.isHidden = true
        lblKgCm.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
        lblBmr.text = "BMR:"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtAge.resignFirstResponder()
        txtWeight.resignFirstResponder()
        txtHeightCm.resignFirstResponder()
        txtFeet.resignFirstResponder()
        txtInches.resignFirstResponder()
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
        return true
    }
    
    //Men	BMR = (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) + 5
    //Women	BMR = (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) - 161
    
    @IBAction func txtHeightAction(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction func txtWeightAction(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction func txtAgeAction(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction func txtFeetAction(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction func txtInchAction(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    @IBAction func switchActionMF(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
        lblBmr.text = "BMR:"
        if switchMF.isOn {
            imgSex.image = UIImage(named: "female29")
            lblMaintain.text = "calorie to maintain weight"
            lblHalf.text = "calorie to lose weight"
            lblFull.text = "calorie to lose weight"
            lblHalfPlus.text = "calorie to gain weight"
            lblFullPlus.text = "calorie to gain weight"
        }else{
            imgSex.image = UIImage(named: "male29")
            lblMaintain.text = "calorie to maintain weight"
            lblHalf.text = "calorie to lose weight"
            lblFull.text = "calorie to lose weight"
            lblHalfPlus.text = "calorie to gain weight"
            lblFullPlus.text = "calorie to gain weight"
        }
    }
    
    @IBAction func switchActionKGLBS(_ sender: Any) {
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
        lblBmr.text = "BMR:"
        if switchKGLBS.isOn {
            txtWeight.placeholder = "weight(lbs)"
            lblLbs.isHidden = false
            lblKgCm.isHidden = true
            txtFeet.isHidden = false
            txtInches.isHidden = false
            txtHeightCm.isHidden = true
            lblMaintain.text = "calorie to maintain weight"
            lblHalf.text = "calorie to lose weight"
            lblFull.text = "calorie to lose weight"
            lblHalfPlus.text = "calorie to gain weight"
            lblFullPlus.text = "calorie to gain weight"
        }else{
            //lblLbs.text = "Kg/Cm"
            txtWeight.placeholder = "weight(kg)"
            lblLbs.isHidden = true
            lblKgCm.isHidden = false
            txtFeet.isHidden = true
            txtInches.isHidden = true
            txtHeightCm.isHidden = false
            lblMaintain.text = "calorie to maintain weight"
            lblHalf.text = "calorie to lose weight"
            lblFull.text = "calorie to lose weight"
            lblHalfPlus.text = "calorie to gain weight"
            lblFullPlus.text = "calorie to gain weight"
        }
    }
    
    @IBAction func segmentActionDRI(_ sender: Any) {
        
        txtAge.resignFirstResponder()
        txtWeight.resignFirstResponder()
        txtHeightCm.resignFirstResponder()
        txtFeet.resignFirstResponder()
        txtInches.resignFirstResponder()
        
        if switchKGLBS.isOn {
            if (Int(txtAge.text!) != nil) && (Int(txtWeight.text!) != nil || Float(txtWeight.text!) != nil) && (Int(txtFeet.text!) != nil){
                if (Int(txtInches.text!) == nil) {
                    txtInches.text = "0"
                }
                let dri = bmrCalculation()
                //print(a)
                if dri > 0{
                    switch segmentDRI.selectedSegmentIndex {
                    case 0:
                        driValueDisplay(driVal: Int(dri * 1.2))
                    case 1:
                        driValueDisplay(driVal: Int(dri * 1.375))
                    case 2:
                        driValueDisplay(driVal: Int(dri * 1.55))
                    case 3:
                        driValueDisplay(driVal: Int(dri * 1.725))
                    case 4:
                        driValueDisplay(driVal: Int(dri * 1.9))
                    default:
                        break
                    }
                }
            }else{
                alertView(message: "add required details")
                print("not intt lbsss")
            }
        }else{
            if (Int(txtAge.text!) != nil) && (Int(txtWeight.text!) != nil || Float(txtWeight.text!) != nil) && (Int(txtHeightCm.text!) != nil || Float(txtHeightCm.text!) != nil){
                let dri = bmrCalculation()
                if dri > 0{
                switch segmentDRI.selectedSegmentIndex {
                    case 0:
                        driValueDisplay(driVal: Int(dri * 1.2))
                    case 1:
                        driValueDisplay(driVal: Int(dri * 1.375))
                    case 2:
                        driValueDisplay(driVal: Int(dri * 1.55))
                    case 3:
                        driValueDisplay(driVal: Int(dri * 1.725))
                    case 4:
                        driValueDisplay(driVal: Int(dri * 1.9))
                    default:
                        break
                    }
                }
            }else{
                alertView(message: "add required details")
                print("not intt")
            }
        }
    }

    @IBAction func btnCalorieInfo(_ sender: Any) {
        btnClose.isEnabled = true
        btnClose.tintColor = .black
        barTitle.title = "What is BMR?"
        viewInfo.isHidden = false
        txtViewInfo.text = "The Basal Metabolic Rate (BMR) Calculator estimates your basal metabolic rate—the amount of energy expended while at rest in a neutrally temperate environment, and in a post-absorptive state (meaning that the digestive system is inactive, which requires about 12 hours of fasting). This calculator is based on the Mifflin - St Jeor equation. \n\nReference: \nThe Basal Metabolic Rate (BMR) is the amount of energy you need while resting in a temperate environment during the post-absorptive state, or when your digestive system is inactive. In such a state, your energy will be used only to maintain your vital organs, which include the heart, lungs, kidneys, the nervous system, intestines, liver, lungs, sex organs, muscles, and skin. The BMR decreases with age and increases with muscle mass \n\nThe BMR is measured under very restrictive circumstances while awake. An accurate BMR measurement requires that a person's sympathetic nervous system is inactive, which means the person must be completely rested. Basal metabolism is usually the largest component of a person's total caloric needs. The daily calorie needs is the BMR value multiplied by a factor with a value between 1.2 and 1.9, depending on the activity level."
    }
    
    @IBAction func btnViewClose(_ sender: Any) {
        btnClose.isEnabled = false
        btnClose.tintColor = .clear
        barTitle.title = "BMR + Calorie calculator"
        viewInfo.isHidden = true
    }

    
    func alertView(message: String){
        let alert = UIAlertController(title: "oooops!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        segmentDRI.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    
    func driValueDisplay(driVal :Int){
        let cal = "Cal"
        if switchKGLBS.isOn{
            if driVal >= 1000{
                lblMaintain.text = "maintain weight- " + String(driVal) + cal
            }else{
                lblMaintain.text = "maintain weight- " + "1000" + cal
            }
        
            let half = driVal - 500
            if half >= 1000{
                lblHalf.text = "lose 0.5lbs- " + String(half) + cal
            }else{
                lblHalf.text = "lose 0.5lbs- " + "1000" + cal
            }
        
            let full = driVal - 1000
            if full >= 1000 {
                lblFull.text = "lose 1lbs- " + String(full) + cal
            }else{
                lblFull.text = "lose 1lbs- " + "1000" + cal
            }
        
            let halfPlus = driVal + 500
            if halfPlus >= 1000 {
                lblHalfPlus.text = "gain 0.5lbs- " + String(halfPlus) + cal
            }else{
                lblHalfPlus.text = "gain 0.5lbs- " + "1000" + cal
            }
        
            let fullPlus = driVal + 1000
            if fullPlus >= 1000 {
                lblFullPlus.text = "gain 1lbs- " + String(fullPlus) + cal
            }else{
                lblFullPlus.text = "gain 1lbs- " + "1000" + cal
            }
        }else{
            if driVal >= 1000{
                lblMaintain.text = "maintain weight- " + String(driVal) + cal
            }else{
                lblMaintain.text = "maintain weight- " + "1000" + cal
            }
            
            let half = driVal - 500
            if half >= 1000{
                lblHalf.text = "lose 0.5kg- " + String(half) + cal
            }else{
                lblHalf.text = "lose 0.5kg- " + "1000" + cal
            }
            
            let full = driVal - 1000
            if full >= 1000 {
                lblFull.text = "lose 1kg- " + String(full) + cal
            }else{
                lblFull.text = "lose 1kg- " + "1000" + cal
            }
            
            let halfPlus = driVal + 500
            if halfPlus >= 1000 {
                lblHalfPlus.text = "gain 0.5kg- " + String(halfPlus) + cal
            }else{
                lblHalfPlus.text = "gain 0.5kg- " + "1000" + cal
            }
            
            let fullPlus = driVal + 1000
            if fullPlus >= 1000 {
                lblFullPlus.text = "gain 1kg- " + String(fullPlus) + cal
            }else{
                lblFullPlus.text = "gain 1kg- " + "1000" + cal
            }
        }
    }
    
    func bmrCalculation() -> Float{

        if switchKGLBS.isOn{
            let feet = txtFeet.text!
            let inches = txtInches.text!
            let tempHeight = Float(feet + "." + inches)!
            let hight = tempHeight / 0.032808
            
            let lbs = Float(txtWeight.text!)!
            let weight = lbs / 2.2046
            print("cccc",hight,weight)
            let age = Float(txtAge.text!)!
            
            if age <= 123 && hight <= 300 && weight <= 300{
                if switchMF.isOn{
                    /////cm kg women
                    let temp = ((10 * weight) + (6.25 * hight) - (5 * age)) - 161
                    let bmr = String(format: "%.0f", temp)
                    lblBmr.text = "BMR: " + String(bmr)
                    return temp
                }else{
                    /////cm kg men
                    let temp = ((10 * weight) + (6.25 * hight) - (5 * age)) + 5
                    let bmr = String(format: "%.0f", temp)
                    lblBmr.text = "BMR: " + String(bmr)
                    return temp
                }
            }else{
                alertView(message: "enter age less than 125, height less than 9feet, weight less than 600lbs")
                return 0
            }
            
        }else{
            let age = Float(txtAge.text!)!
            let hight = Float(txtHeightCm.text!)!
            let weight = Float(txtWeight.text!)!
        
            if age <= 123 && hight <= 300 && weight <= 670{
            if switchMF.isOn{
                /////cm kg women
                let temp = ((10 * weight) + (6.25 * hight) - (5 * age)) - 161
                let bmr = String(format: "%.0f", temp)
                lblBmr.text = "BMR: " + String(bmr)
                return temp
            }else{
                /////cm kg men
                let temp = ((10 * weight) + (6.25 * hight) - (5 * age)) + 5
                let bmr = String(format: "%.0f", temp)
                lblBmr.text = "BMR: " + String(bmr)
                return temp
                }
            }else{
                alertView(message: "enter age less than 125, height less than 9feet, weight less than 600lbs")
                return 0
            }
        }
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

/*extension UIViewController
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
}*/
