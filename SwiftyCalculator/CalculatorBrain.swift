//
//  CalculatorBrain.swift
//  SwiftyCalculator
//
//  Created by Steve Malsam on 5/21/15.
//  Copyright (c) 2015 Basting Shoebox Software. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op : Printable {
        case Operand(Double)
        case ConstantOperator(String, Double)
        case UnaryOperator(String, Double -> Double)
        case BinaryOperator(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                    
                case .ConstantOperator(let symbol, _):
                    return symbol
                    
                case .UnaryOperator(let symbol, _):
                    return symbol
                    
                case .BinaryOperator(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    var stackState: String {
        get {
            return join("\n", opStack.map({$0.description}))
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperator("×") {$0 * $1})
        learnOp(Op.BinaryOperator("÷") {$1 / $0})
        learnOp(Op.BinaryOperator("+") {$0 + $1})
        learnOp(Op.BinaryOperator("−") {$1 - $0})
        learnOp(Op.UnaryOperator("√") {sqrt($0)})
        learnOp(Op.UnaryOperator("sin") {sin($0)})
        learnOp(Op.UnaryOperator("cos") {cos($0)})
        learnOp(Op.ConstantOperator("π", M_PI))
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
        
            var remainingOps = ops
            let op = remainingOps.removeLast()
        
            switch op {
            case .Operand(let operand):
                return(operand, remainingOps)
                
            case .ConstantOperator(_, let value):
                return(value, remainingOps)
            
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
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
}