//
//  SettingsViewController.swift
//  Tips
//
//  Created by Jennifer Lee on 8/7/15.
//  Copyright (c) 2015 Jennifer Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var servicePicker: UIPickerView!
    @IBOutlet weak var defaultTipLabel: UILabel!
    let constants = TipConstants()
    let defaults = NSUserDefaults.standardUserDefaults()


    @IBAction func donePressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addDefaultTip(sender: AnyObject) {
        updateDefaultTip(1)
    }
    @IBAction func subtractDefaultTip(sender: AnyObject) {
        updateDefaultTip(-1)
    }

    func updateDefaultTip(delta: Int) {
        var tipPercent: Int = 0
        var tipLabelStr = defaultTipLabel.text as NSString?
        let tipLabelStrLen = tipLabelStr?.length

        if let tipLabelVal = tipLabelStr?.substringToIndex(tipLabelStrLen! - 1).toInt() {
            tipPercent = tipLabelVal + delta

            // Store Default Tip Amount into Storage
            defaults.setInteger(tipPercent, forKey:"defaultTipAmount")
            defaults.synchronize()

        } else {
            println("Tip percent is unparseable.")
        }

        defaultTipLabel.text = String(format: "%d%%", tipPercent)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show default Tip Amount from Storage.
        var defaults = NSUserDefaults.standardUserDefaults()
        var tipPercent: Int = defaults.integerForKey("defaultTipAmount")
        defaultTipLabel.text = String(tipPercent) + "%"

        // Set up service picker
        servicePicker.dataSource = self
        servicePicker.delegate = self

    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return constants.tipGuide.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Array(constants.tipGuide.keys)[row]
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        defaults.setInteger(row, forKey:"serviceType")
        defaults.synchronize()
        self.view.endEditing(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let row = defaults.integerForKey("serviceType")
        servicePicker.selectRow(row, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
