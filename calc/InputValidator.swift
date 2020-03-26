//
//  InputValidator.swift
//  calc
//
//  Created by Nikita Sergeev on 24/3/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

//
// Extension of String for some minor convinience
//
extension String {
    var isNumber: Bool {
        var str = self
        if str.first == "+" {
            str.removeFirst()
        }
        return NumberFormatter().number(from: str) != nil
    }
    
    var isOperator: Bool {
        if ["+", "-", "x", "/", "%"].contains(self) {
            return true
        }
        return false
    }
    
    var isLowPriorityOperator: Bool {
        if ["+", "-"].contains(self) {
            return true
        }
        return false
    }
}

//
// Class extracts information from receiving
// input and analyses its correctness
//
class InputValidator {
    // An atom is a number or string of contiguous characters in Lisp
    // It includes numbers and special characters.
    private var atoms = [String]()
    
    init(inputArray: [String]) throws {
        do {
            if try InputIsValid(inputArray: inputArray) {
                self.atoms = inputArray
            }
        } catch {
            throw error
        }
    }
    
    public func getAtoms() -> [String] {
        return atoms
    }
    
    func InputIsValid(inputArray: [String]) throws -> Bool {
        if inputArray.isEmpty {
            throw ErrorHandler.InputError.inputIsEmpty
        }
        
        var counter = 0
        for atom in inputArray {
            if counter % 2 == 0 {
                if !atom.isNumber {
                    if !atom.isOperator {
                        throw ErrorHandler.InputError.missedNumber(at: counter, operator: atom)
                    }
                    throw ErrorHandler.InputError.invalidOperator(operator: atom)
                }
            } else {
                if !atom.isOperator {
                    if !atom.isNumber {
                        throw ErrorHandler.InputError.missedOperator(at: counter, operator: atom)
                    }
                    throw ErrorHandler.InputError.invalidNumber(number: atom)
                }
            }
            
            // it is separate because it might be inefficient to check it each counter % 2 != 0
            // in case there are many atoms
            if inputArray[inputArray.count-1].isOperator {
                throw ErrorHandler.InputError.endedWithOperator(operator: inputArray[inputArray.count-1])
            }
            
            counter += 1
        }
        return true
    }
}
