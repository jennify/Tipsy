//
//  ViewController.swift
//  Tips
//
//  Created by Jennifer Lee on 8/6/15.
//  Copyright (c) 2015 Jennifer Lee. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billingView: UIView!
    var defaultTipAmount: NSNumber = -1
    let currencyFormatter: NSNumberFormatter = NSNumberFormatter()
    let constants = TipConstants()
    var lowerlimit = 10
    var upperlimit = 20
    let defaults = NSUserDefaults.standardUserDefaults()

    // Entry Point
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init currency formatter.
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.locale = NSLocale.currentLocale()
        currencyFormatter.numberStyle = .CurrencyStyle

        // Set default labels.
        billField.text = currencyFormatter.currencySymbol
        var defaultTipAmount = defaults.integerForKey("defaultTipAmount")
        tipLabel.text = String(defaultTipAmount) + "%"
        totalLabel.text = currencyFormatter.stringFromNumber(0.00)
        tipAmountLabel.text = currencyFormatter.stringFromNumber(0.00)

        // Load Cache
        if defaults.objectForKey("lastUpdate") != nil {
            let lastUpdateTS = defaults.objectForKey("lastUpdate") as NSDate
            let tenMinsAgo = NSDate(timeIntervalSinceReferenceDate: 10*60*60)
            if lastUpdateTS.compare(tenMinsAgo) == NSComparisonResult.OrderedDescending {
                billField.text = defaults.objectForKey("bill") as String
                tipLabel.text = defaults.objectForKey("tipPercent") as String
            }
        }

        updateTipValue(0)
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var typeIndex = defaults.integerForKey("serviceType")
        let serviceType: String = Array(constants.tipGuide.keys)[typeIndex]
        let (lower, upper) = constants.tipGuide[serviceType]!
        lowerlimit = lower
        upperlimit = upper

        billField.becomeFirstResponder()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Cache results.
        defaults.setObject(billField.text, forKey: "bill")
        defaults.setObject(tipLabel.text, forKey: "tipPercent")
        defaults.setObject(NSDate(), forKey: "lastUpdate")

        defaults.synchronize()
    }

    @IBAction func onTap(sender: AnyObject) {

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
        var tipPercent: Int = 0
        var tipLabelStr = tipLabel.text as NSString?
        let tipLabelStrLen = tipLabelStr?.length

        if let tipLabelVal = tipLabelStr?.substringToIndex(tipLabelStrLen! - 1).toInt() {
            tipPercent = tipLabelVal + delta
        } else {
            println("Tip percent is unparseable.")
        }
        var tip = billAmount *  (Double(tipPercent) / 100)
        if tip < 0 {
            // Exit if tip falls negative.
            return
        }
        var total = billAmount + tip

        var color = UIColor.whiteColor()
        if tipPercent < lowerlimit {
            color = UIColor(red: 0xff, green: 0x00, blue: 0x00, alpha: 0.2)
        } else if tipPercent > upperlimit {
            color = UIColor(red: 0x00, green: 0xee, blue: 0xff, alpha: 0.2)
        } else {
            color = UIColor(red: 0x00, green: 0xee, blue: 0x00, alpha: 0.2)
        }

        UIView.animateWithDuration(0.5, animations:{
            self.billingView.backgroundColor = color;
        });

        tipLabel.text = String(format: "%d%%", tipPercent)
        tipAmountLabel.text = currencyFormatter.stringFromNumber(tip)!
        totalLabel.text = currencyFormatter.stringFromNumber(total)!
    }

    @IBAction func onEditBegin(sender: AnyObject) {
        if billField.text == currencyFormatter.currencySymbol {
            billField.text = ""
        }
    }

    @IBAction func onEditEnd(sender: AnyObject) {
        if billField.text == "" {
            billField.text = currencyFormatter.currencySymbol
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateTipValue(0)
    }

    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let velocity = recognizer.velocityInView(self.view)
        if velocity.x > 0 {
            updateTipValue(1)
        } else {
            updateTipValue(-1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

