//
//  ViewController.swift
//  Tips
//
//  Created by Jennifer Lee on 8/6/15.
//  Copyright (c) 2015 Jennifer Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billingView: UIView!

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func increaseTipTap(sender: AnyObject) {
        updateTipValue(1)
    }
    @IBAction func decreaseTipTap(sender: AnyObject) {
        updateTipValue(-1)
    }

    func updateTipValue(delta: Int) {

        var billAmount = (billField.text as NSString).doubleValue

        // Some Magical Hack to get Optionals working.
        var tipPercent: Int = 15
        var tipLabelStr = tipLabel.text as NSString?
        let tipLabelStrLen = tipLabelStr?.length

        if let tipLabelVal = tipLabelStr?.substringToIndex(tipLabelStrLen! - 1).toInt() {
            tipPercent = tipLabelVal + delta
        } else {
            println("Tip percent is unparseable.")
        }

        var tip = billAmount *  (Double(tipPercent) / 100)
        var total = billAmount + tip

        if tipPercent < 15 {
            billingView.backgroundColor = UIColor(red: 0xff, green: 0x00, blue: 0x00, alpha: 0.5)
        } else {
            billingView.backgroundColor = UIColor(red: 0x00, green: 0xee, blue: 0xff, alpha: 0.5)

        }

        tipLabel.text = String(format: "%d%%", tipPercent)
        tipAmountLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        totalLabel.text = "$0.00"
        billField.text = "$"
        tipAmountLabel.text = "$0.00"
        tipLabel.text = "15%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditBegin(sender: AnyObject) {
        if billField.text == "$" {
            billField.text = ""
        }

    }
    @IBAction func onEditEnd(sender: AnyObject) {
        if billField.text == "" {
            billField.text = "$"
        }
    }
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTipValue(0)
    }
}

