//
//  CalculatorBrain.swift
//  SwiftyCalculator
//
//  Created by Steve Malsam on 5/21/15.
//  Copyright (c) 2015 Basting Shoebox Software. All rights reserved.
//

import Foundation

class CalculatorBrain {
    enum Op {
        case Operand(Double)
        case UnaryOperator(String, Double -> Double)
        case BinaryOperator(String, (Double, Double) -> Double)
    }
    
    var opStack = [Op]()
    var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperator("×") {$0 * $1}
        knownOps["÷"] = Op.BinaryOperator("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperator("+") {$0 + $1}
        knownOps["−"] = Op.BinaryOperator("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperator("√") {sqrt($0)}
    }
}