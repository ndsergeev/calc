//
//  Calculator.swift
//  calc
//
//  Created by Nikita Sergeev on 24/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    private let inputValidator: InputValidator
    
    init(inputArray: [String]) throws {
        do {
            inputValidator = try InputValidator(inputArray: inputArray)
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
        if b == 0 {
            throw ErrorHandler.OperationError.divisionByZero
        }
        return a / b
    }
    
    func mod(a: Int, b: Int) throws -> Int {
        if b == 0 {
            throw ErrorHandler.OperationError.divisionByZero
        }
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
        // The function iterates through all atoms and
        // creates arrays of numbers and operators.
        // It calculates high priority
        var oprs = [String]()
        var nums = [Int]()
        let atoms = inputValidator.getAtoms()
        
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
                        oprs.removeLast()
                    } catch {
                        throw error
                    }
                    iter += 2
                }
            }
        }
        
        // Deals with rest low priority atoms by
        // summarising or subtracting with the first element
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
