//
//  ViewController.swift
//  tipCalculator
//
//  Created by Abid Amirali on 11/20/16.
//  Copyright © 2016 Abid Amirali. All rights reserved.
//

import UIKit

var lastAmount = ""
var lastPeople = ""
class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var selectedTipSegment: UISegmentedControl!
    
    @IBOutlet weak var numOfPeopleField: UITextField!
	@IBOutlet weak var userAmountLabel: UILabel!
	var peoplePicker:UIPickerView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var calcView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
	let peoplePickerValues = ["1","2", "3", "4", "5", "6", "7", "8", "9", "10"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		peoplePicker = UIPickerView()
		
		peoplePicker.dataSource = self
		peoplePicker.delegate = self
		
		numOfPeopleField.inputView = peoplePicker
		numOfPeopleField.text = peoplePickerValues[0]

		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
		self.calcView.alpha = 0
        let defaultTip = NSUserDefaults.standardUserDefaults().integerForKey("defaultTip") ?? 0
        self.selectedTipSegment.selectedSegmentIndex = defaultTip
		let defaultPeople:String = (NSUserDefaults.standardUserDefaults().objectForKey("defaultPeople") ?? "1") as! String
		let currDate = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd,MM,mm"
		let formatedDate = dateFormatter.stringFromDate(currDate)
		let prevDate:String = (NSUserDefaults.standardUserDefaults().objectForKey("lastDate") ?? "") as! String
		if (prevDate.characters.count > 0) {
			let currDateParts = formatedDate.componentsSeparatedByString(",")
			let prevDateParts = prevDate.componentsSeparatedByString(",")
		
			if (currDateParts[0] == prevDateParts[0] && currDateParts[1] == prevDateParts[1]) {
				let newTime = Int(currDateParts[2])! ?? 0
				let oldtime = Int(prevDateParts[2])! ?? 0
				if (newTime - oldtime <= 10) {
					let prevBill =	(NSUserDefaults.standardUserDefaults().objectForKey("lastAmount") ?? "0.00") as! String
					if (prevBill.characters.count > 0) {
						billField.text = "\(prevBill)"
						self.numOfPeopleField.text = defaultPeople
						calculateTip(self)
					} else {
						billField.text = "0.00"
					}
				}
			}
		}
    }

    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true);
    }


    @IBAction func calculateTip(sender: AnyObject) {
        let amount:Double = Double(billField.text!) ?? 0
        let tipPercentages:[Double] = [0.10, 0.18, 0.2]
        let currectTipPecentage:Double = tipPercentages[selectedTipSegment.selectedSegmentIndex]
        let tip:Double = amount * currectTipPecentage
        let totalAmount:Double = amount + tip
        self.tipLabel.text = String(format: "$%.2f", tip)
        self.totalLabel.text = String(format: "$%.2f", totalAmount)
		lastAmount = billField.text!
		let amountDivisor = Double(numOfPeopleField.text!) ?? 0
		let userAmount:Double = totalAmount / amountDivisor
		self.userAmountLabel.text = String(format: "$%.2f", userAmount)
		if (amount == 0) {
			billField.text = "0.00"
		}
    }
    
    @IBAction func updateTipAmount(sender: AnyObject) {
		calculateTip(self)
    }
    
    @IBAction func percentageChanged(sender: AnyObject) {
        self.calculateTip(sender)
    }
	
	
	override func viewDidAppear(animated: Bool) {
		UIView.animateWithDuration(1, animations: {
			self.calcView.alpha = 1
		})
	}
	
	override func viewWillDisappear(animated: Bool) {
		NSUserDefaults.standardUserDefaults().setObject(lastAmount, forKey: "lastAmount")
		let currDate = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd,MM,mm"
		let formatedDate = dateFormatter.stringFromDate(currDate)
		NSUserDefaults.standardUserDefaults().setObject(formatedDate, forKey: "lastDate")
		NSUserDefaults.standardUserDefaults()
		lastAmount = billField.text ?? "0.00"
		lastPeople = numOfPeopleField.text ?? "1"
	}
	
	
	//MARK: Picker Methods
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return peoplePickerValues.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
		return peoplePickerValues[row]
	}
	
	func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
		numOfPeopleField.text = peoplePickerValues[row]
		self.calculateTip(self)
		self.view.endEditing(true)
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
		if (segue.identifier == "toSettings") {
			if let settingVC = segue.destinationViewController as? SettingsViewController {
				settingVC.peoplePickerValues = peoplePickerValues
			}
		}
	}
}

