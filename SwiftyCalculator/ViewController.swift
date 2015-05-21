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
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        switch operation {
        case "×":
            if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() * operandStack.removeLast()
                enter()
            }
        case "÷":
            if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() / operandStack.removeLast()
                enter()
            }
        case "+":
            if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() + operandStack.removeLast()
                enter()
            }
        case "−":
            if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() - operandStack.removeLast()
                enter()
            }
        default:break
        }
    }

    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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

