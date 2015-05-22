//
//  ViewController.swift
//  SwiftyCalculator
//
//  Created by Steve Malsam on 5/14/15.
//  Copyright (c) 2015 Basting Shoebox Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingNumber : Bool = false
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
    }
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }

}

