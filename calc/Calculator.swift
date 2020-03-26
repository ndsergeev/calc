//
//  Calculator.swift
//  calc
//
//  Created by Nikita Sergeev on 24/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

enum ErrorHandler: Error {
    enum InputError: Error {
        case inputIsEmpty
        case endedWithOperator(operator: String)
        case missedOperator(at: Int, operator: String)
        case missedNumber(at: Int, operator: String)
        case invalidOperator(operator: String)
        case invalidNumber(number: String)
    }
    
    enum OperationError: Error {
        case divisionByZero
    }
}

class Calculator {
    private let parser: Parser
    
    init(inputArray: [String]) throws {
        do {
            parser = try Parser(inputArray: inputArray)
        } catch {
            throw error
        }
    }
    
    //
    // Operations with
    //
    func add(a: Int, b: Int) -> Int {
        return a + b
    }
    
    func sub(a: Int, b: Int) -> Int {
        return a - b
    }
    
    func mul(a: Int, b: Int) -> Int {
        return a * b
    }
    
    func div(a: Int, b: Int) throws -> Int {
        if b == 0 { throw ErrorHandler.OperationError.divisionByZero }
        return a / b
    }
    
    func mod(a: Int, b: Int) throws -> Int {
        if b == 0 { throw ErrorHandler.OperationError.divisionByZero }
        return a % b
    }
    
    func highPriorityOperation(a: Int, o: String, b: Int) throws -> Int {
        do {
            switch o {
            case "x":
                return self.mul(a: Int(a), b: Int(b))
            case "/":
                return try self.div(a: Int(a), b: Int(b))
            case "%":
                return try self.mod(a: Int(a), b: Int(b))
            default:
                throw ErrorHandler.InputError.invalidOperator(operator: o)
            }
        } catch {
            throw error
        }
    }
    
    func lowPriorityOperation(a: Int, o: String, b: Int) throws -> Int {
        do {
            switch o {
            case "+":
                return self.add(a: Int(a), b: Int(b))
            case "-":
                return self.sub(a: Int(a), b: Int(b))
            default:
                throw ErrorHandler.InputError.invalidOperator(operator: o)
            }
        } catch {
            throw error
        }
    }
    
    public func calculate() throws -> Int {
        var oprs = [String]()
        var nums = [Int]()
        let atoms = parser.getAtoms()
        
        var iter: Int = 0
        while iter < atoms.count {
            if iter % 2 == 0 {
                nums.append(Int(atoms[iter])!)
                iter += 1
            } else {
                oprs.append(atoms[iter])
                if atoms[iter].isLowPriorityOperator {
                    iter += 1
                } else {
                    do {
                        nums[nums.count-1] = try highPriorityOperation(a: nums[nums.count-1],
                                                                       o: oprs[oprs.count-1],
                                                                       b: Int(atoms[iter+1])!)
                    } catch {
                        throw error
                    }
                    iter += 2
                 }
            }
        }
        
        if nums.count > 1 {
            iter = 1
            while iter < nums.count {
                nums[0] = try lowPriorityOperation(a: nums[0] , o: oprs[0], b: nums[iter])
                oprs.removeFirst()
                iter += 1
            }
        }
        
        return nums[0]
    }
}
