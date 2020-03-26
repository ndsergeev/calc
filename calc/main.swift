//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

//args = ["4", "+", "3", "x", "2"]
//args = ["54", "-", "99"]
//args = ["-40"]
//args = ["x"]
//args = ["12", "+"]
args = ["41", "x", "43", "+", "48"]

do {
    let calc = try Calculator(inputArray: args)
    print(try calc.calculate())
} catch ErrorHandler.OperationError.divisionByZero {
    print("Exited with zero division.")
    exit(1)
} catch ErrorHandler.InputError.inputIsEmpty {
    print("Exited with empty input.")
    exit(1)
} catch ErrorHandler.InputError.invalidNumber(let number) {
    print("Exited with invalid number \'\(number)\'.")
    exit(1)
} catch ErrorHandler.InputError.invalidOperator(let operatorSymbol) {
    print("Exited with invalid operator \'\(operatorSymbol)\'.")
    exit(1)
}catch ErrorHandler.InputError.missedNumber(let position, let number) {
    print("Exited with invalid number \'\(number)\' at position \(position).")
    exit(1)
} catch ErrorHandler.InputError.missedOperator(let position, let operatorSymbol) {
    print("Exited with invalid operator \'\(operatorSymbol)\' at position \(position).")
    exit(1)
} catch ErrorHandler.InputError.endedWithOperator(let operatorSymbol) {
    print("Exited with last operator \'\(operatorSymbol)\' in the input.")
    exit(1)
}
