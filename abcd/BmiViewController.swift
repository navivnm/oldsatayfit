//
//  BmiViewController.swift
//  abcd
//
//  Created by Naveen Vijay on 19/04/17.
//  Copyright © 2017 Naveen Vijay. All rights reserved.
//

import UIKit

class BmiViewController: UIViewController {

    var weight = Float()
    var height = Float()
    //var bmi = Float()
    
    @IBOutlet weak var sliderWeight: UISlider!
    @IBOutlet weak var sliderHeight: UISlider!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblBmi: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderWeightBmi(_ sender: UISlider) {
        weight = Float(sliderWeight.value)
        weight = round(100 * weight) / 100
        let temp = String(format: "%.0f", weight)
        lblWeight.text = "your weight: \(temp) kg"
        //print(weight)
        bmiCalculation()
    }
    
    @IBAction func sliderHeightBmi(_ sender: UISlider) {
        height = Float(sliderHeight.value)
        height = round(100 * height) / 100
        let temp = String(format: "%.0f", height)
        lblHeight.text = "your height: " + temp + "cm"//"\(temp) cm"
        bmiCalculation()
    }
    
    @IBAction func btnBmi(_ sender: Any) {
        bmiCalculation()
    }
    
    func bmiCalculation(){
        //print(weight,height)
        let temp0 = Float(height/100)
        //print(temp0)
        let temp1 = temp0*temp0
        //print(temp1)
        let temp2 = weight/temp1
        
        if temp2 >= 0 && temp2 <= 2500 {
            let bmi = String(format: "%.1f", temp2)
            lblBmi.text = "your bmi: " + bmi
            aboutBmiValue(bmi: temp2)
        }
    }
    
    func aboutBmiValue(bmi: Float){
        //print("about...",bmi)
        if bmi < 18.5 {
            print("underweight")
        }else if bmi > 18.5 && bmi < 24.99{
            print("normal")
        }else if bmi > 25 && bmi < 29.99{
            print("overweight")
        }else if bmi > 30 && bmi < 34.99{
            print("Obesity (Class 1)")
        }else if bmi > 35 && bmi < 39.99{
            print("Obesity (Class 2)")
        }else{
         print("Morbid Obesity")
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
