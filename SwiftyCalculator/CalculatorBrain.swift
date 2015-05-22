//
//  CalculatorBrain.swift
//  SwiftyCalculator
//
//  Created by Steve Malsam on 5/21/15.
//  Copyright (c) 2015 Basting Shoebox Software. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case UnaryOperator(String, Double -> Double)
        case BinaryOperator(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperator("×") {$0 * $1}
        knownOps["÷"] = Op.BinaryOperator("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperator("+") {$0 + $1}
        knownOps["−"] = Op.BinaryOperator("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperator("√") {sqrt($0)}
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
        
            var remainingOps = ops
            let op = remainingOps.removeLast()
        
            switch op {
            case .Operand(let operand):
                return(operand, remainingOps)
            
            case .UnaryOperator(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), remainingOps)
                }
            
            case .BinaryOperator(_, let operation):
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        return (operation(operand1, operand2), operand2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack);
        return result
    }
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}