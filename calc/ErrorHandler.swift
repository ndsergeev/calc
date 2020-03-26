//
//  ErrorHandler.swift
//  calc
//
//  Created by Nikita Sergeev on 26/3/20.
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
