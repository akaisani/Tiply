//
//  SettingsViewController.swift
//  tipCalculator
//
//  Created by Abid Amirali on 11/20/16.
//  Copyright © 2016 Abid Amirali. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var defaultPeopleField: UITextField!
    @IBOutlet weak var defaultTipSegment: UISegmentedControl!
	var peoplePickerValues:[String]!
	var peoplePicker:UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
		//picker setup
		
		peoplePicker = UIPickerView()
		
		peoplePicker.dataSource = self
		peoplePicker.delegate = self
		
		defaultPeopleField.inputView = peoplePicker
//		numOfPeopleField.text = peoplePickerValues[0]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultTipSet(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(defaultTipSegment.selectedSegmentIndex, forKey: "defaultTip")
        NSUserDefaults.standardUserDefaults()
    }
	@IBAction func defaultPeopleSet(sender: AnyObject) {
		
	}
	
    override func viewWillAppear(animated: Bool) {
        let defaultTip = NSUserDefaults.standardUserDefaults().integerForKey("defaultTip") ?? 0
        self.defaultTipSegment.selectedSegmentIndex = defaultTip
		let defaultPeople:String = (NSUserDefaults.standardUserDefaults().objectForKey("defaultPeople") ?? "1") as! String
		self.defaultPeopleField.text = defaultPeople

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
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		defaultPeopleField.text = peoplePickerValues[row]
		self.view.endEditing(true)
		NSUserDefaults.standardUserDefaults().setObject(defaultPeopleField.text!, forKey: "defaultPeople")
		NSUserDefaults.standardUserDefaults()
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
