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
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var viewBmiInfo: UIView!
    @IBOutlet weak var viewUnder: UIView!
    @IBOutlet weak var viewNormal: UIView!
    @IBOutlet weak var viewOver: UIView!
    @IBOutlet weak var viewObesityOne: UIView!
    @IBOutlet weak var viewObesityTwo: UIView!
    @IBOutlet weak var viewMorbid: UIView!
    
    @IBOutlet weak var txtBmiInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewBmiInfo.isHidden = true
        viewBmiInfo.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        //view.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
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
    
    @IBAction func btnBmiViewClose(_ sender: Any) {
        viewBmiInfo.isHidden = true
    }
    
    @IBAction func btnBmiUnder(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Under Weight"
        txtBmiInfo.text = "The best way to add weight is to increase your intake of complex carbohydrates, particularly whole grain ones. Foods like whole wheat bread, muffins, pasta, crackers, and bagels are good to include. Also, legumes and fruits would be wise choices. \n\nIn order to gain weight, you will have to eat more calories. You will need to include regular exercise and strength training into your lifestyle in order to prevent gaining too much weight as fat. And, as I mentioned, those extra calories should come mainly from additional carbohydrate. \n\nTo start, set up a realistic goal weight for yourself. You may need to resign yourself to a less than (what you may consider) an ideal weight. Make good nutrition your priority, and weight gain the second. \n\nTo start, set up a realistic goal weight for yourself. You may need to resign yourself to a less than (what you may consider) an ideal weight. Make good nutrition your priority, and weight gain the second. \n\nSome more tips \n\nDrink 6-8 glasses of distilled water a day. \n\nEat frequent but small meals. \n\nEat lots of raw fruits and vegetables (green leafy vegetables are great). \n\nDo not drink coffee, alcohol, soda pop \n\nDo not eat processed foods; white sugar, white flower \n\nAvoid red meat and animal fats. \n\nReduce intake of dairy products.\n\nDo not smoke and avoid second hand smoke."
    }

    @IBAction func btnBmiNormal(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Normal"
        txtBmiInfo.text = "People whose BMI is within 18.5 to 24.9 possess the ideal amount of body weight, associated with living longest, the lowest incidence of serious ilness, as well as being perceived as more physically attractive than people with BMI in higher or lower ranges."
    }
    

    @IBAction func btnBmiOver(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Over Weight"
        txtBmiInfo.text = "Your body weight is controlled by the number of calories you eat and the number of calories you use each day. So, if you consume fewer calories than you burn, you will lose weight. You can do this by becoming more physically active or by eating less. \n\nYou didn't put on extra weight overnight so it is equally unrealistic to take it off quickly. Record a goal that you can reach in one month that is 4 to 8 pounds less than you weigh now. Set a goal you know you can achieve. \n\nHere are some very simple changes that you can start today that will greatly improve your chances of weight loss success: \n\nEliminate Red Meat \\nnIf foods like burgers are basic to your current diet, cutting out red meat can go a long way in helping you make healthier meal choices. Build your meals around fish or poultry. \n\nCut out fried foods \n\nGrill, bake, roast, broil or boil your food. This also means doing without French Fries and snack foods like Potato Strings, Chips... \n\nStart with a soup or a salad \n\nBy starting dinner with a soup or salad, you will curb your hunger, which will in turn help you keep portion sizes in check and prevent you from overeating \n\nStop Cola consumption \n\nFor every 20 ounces of Coca-Cola you drink, you're consuming 250 calories. If you're trying to consume around 1500 calories a day in order to lose weight, you can blow your entire calorie budget on soda!. \n\nDrink water \n\nReach for the goal of eight glasses a day. Even if you don't drink eight, you're drinking more than usual."
    }
    
    @IBAction func btnBmiObesityOne(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Obesity(Class 1)"
        txtBmiInfo.text = "The method of treatment depends on your level of obesity, overall health condition, and motivation to lose weight. \n\nTreatment includes a combination of diet, exercise, behavior modification, and sometimes weightloss drugs. In some cases of severe obesity, gastrointestinal surgery may be recommended. \n\nIf you are overweight, losing as little as 7-10 percent of your body weight may improve many of the problems linked to being overweight, such as high blood pressure and diabetes. \n\nSlow and steady weight loss of no more than 1-2 pounds per week is the safest way to lose weight. Too rapid weight loss can cause you to lose muscle rather than fat. It also increases your chances of developing other problems, such as gallstones and nutrient deficiencies. Making long-term changes in your eating and physical activity habits is the only way to lose weight and keep it off! \n\nWhether you are trying to lose weight or maintain your weight, you must improve your eating habits. Eat a variety of foods, especially pasta, rice, wholemeal bread, and other whole-grain foods. Reduce your fat-intake. You should also eat lots of fruits and vegetables. \n\nMaking physical activity a part of your daily life is an important way to help control your weight. Try to do at least 30 minutes of physical activity a day on most days of the week. The activity does not have to be done all at once. It can be done in stages: 10 minutes here, 20 minutes there, providing it adds up to 30 minutes a day."
    }
    
    @IBAction func btnBmiObesityTwo(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Obesity(Class 2)"
        txtBmiInfo.text = "The method of treatment depends on your level of obesity, overall health condition, and motivation to lose weight. \n\nTreatment includes a combination of diet, exercise, behavior modification, and sometimes weightloss drugs. In some cases of severe obesity, gastrointestinal surgery may be recommended. \n\nIf you are overweight, losing as little as 7-10 percent of your body weight may improve many of the problems linked to being overweight, such as high blood pressure and diabetes. \n\nSlow and steady weight loss of no more than 1-2 pounds per week is the safest way to lose weight. Too rapid weight loss can cause you to lose muscle rather than fat. It also increases your chances of developing other problems, such as gallstones and nutrient deficiencies. Making long-term changes in your eating and physical activity habits is the only way to lose weight and keep it off! \n\nWhether you are trying to lose weight or maintain your weight, you must improve your eating habits. Eat a variety of foods, especially pasta, rice, wholemeal bread, and other whole-grain foods. Reduce your fat-intake. You should also eat lots of fruits and vegetables. \n\nMaking physical activity a part of your daily life is an important way to help control your weight. Try to do at least 30 minutes of physical activity a day on most days of the week. The activity does not have to be done all at once. It can be done in stages: 10 minutes here, 20 minutes there, providing it adds up to 30 minutes a day."
    }
    
    @IBAction func btnBmiMorbid(_ sender: Any) {
        viewBmiInfo.isHidden = false
        lblHeading.text = "Morbid Obesity"
        txtBmiInfo.text = "The method of treatment depends on your level of obesity, overall health condition, and motivation to lose weight. \n\nTreatment includes a combination of diet, exercise, behavior modification, and sometimes weightloss drugs. In some cases of severe obesity, gastrointestinal surgery may be recommended. \n\nIf you are overweight, losing as little as 7-10 percent of your body weight may improve many of the problems linked to being overweight, such as high blood pressure and diabetes. \n\nSlow and steady weight loss of no more than 1-2 pounds per week is the safest way to lose weight. Too rapid weight loss can cause you to lose muscle rather than fat. It also increases your chances of developing other problems, such as gallstones and nutrient deficiencies. Making long-term changes in your eating and physical activity habits is the only way to lose weight and keep it off! \n\nWhether you are trying to lose weight or maintain your weight, you must improve your eating habits. Eat a variety of foods, especially pasta, rice, wholemeal bread, and other whole-grain foods. Reduce your fat-intake. You should also eat lots of fruits and vegetables. \n\nMaking physical activity a part of your daily life is an important way to help control your weight. Try to do at least 30 minutes of physical activity a day on most days of the week. The activity does not have to be done all at once. It can be done in stages: 10 minutes here, 20 minutes there, providing it adds up to 30 minutes a day."
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
        }else {
            lblBmi.text = "too high bmi"
        }
        
    }
    
    func aboutBmiValue(bmi: Float){
        //print("about...",bmi)
        if bmi < 18.5 {
            //print("underweight")
            viewUnder.backgroundColor = UIColor.white
            viewNormal.backgroundColor = UIColor.lightText
            viewOver.backgroundColor = UIColor.lightText
            viewObesityOne.backgroundColor = UIColor.lightText
            viewObesityTwo.backgroundColor = UIColor.lightText
            viewMorbid.backgroundColor = UIColor.lightText
        }else if bmi >= 18.5 && bmi < 24.99{
            //print("normal")
            viewUnder.backgroundColor = UIColor.lightText
            viewNormal.backgroundColor = UIColor.white
            viewOver.backgroundColor = UIColor.lightText
            viewObesityOne.backgroundColor = UIColor.lightText
            viewObesityTwo.backgroundColor = UIColor.lightText
            viewMorbid.backgroundColor = UIColor.lightText
        }else if bmi >= 25 && bmi < 29.99{
            //print("overweight")
            viewUnder.backgroundColor = UIColor.lightText
            viewNormal.backgroundColor = UIColor.lightText
            viewOver.backgroundColor = UIColor.white
            viewObesityOne.backgroundColor = UIColor.lightText
            viewObesityTwo.backgroundColor = UIColor.lightText
            viewMorbid.backgroundColor = UIColor.lightText
        }else if bmi >= 30 && bmi < 34.99{
            //print("Obesity (Class 1)")
            viewUnder.backgroundColor = UIColor.lightText
            viewNormal.backgroundColor = UIColor.lightText
            viewOver.backgroundColor = UIColor.lightText
            viewObesityOne.backgroundColor = UIColor.white
            viewObesityTwo.backgroundColor = UIColor.lightText
            viewMorbid.backgroundColor = UIColor.lightText
        }else if bmi >= 35 && bmi < 39.99{
            //print("Obesity (Class 2)")
            viewUnder.backgroundColor = UIColor.lightText
            viewNormal.backgroundColor = UIColor.lightText
            viewOver.backgroundColor = UIColor.lightText
            viewObesityOne.backgroundColor = UIColor.lightText
            viewObesityTwo.backgroundColor = UIColor.white
            viewMorbid.backgroundColor = UIColor.lightText
        }else{
            //print("Morbid Obesity")
            viewUnder.backgroundColor = UIColor.lightText
            viewNormal.backgroundColor = UIColor.lightText
            viewOver.backgroundColor = UIColor.lightText
            viewObesityOne.backgroundColor = UIColor.lightText
            viewObesityTwo.backgroundColor = UIColor.lightText
            viewMorbid.backgroundColor = UIColor.white
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
