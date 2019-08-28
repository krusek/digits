//
//  number.swift
//  digits
//
//  Created by Korben Rusek on 8/27/19.
//

import Foundation

public enum Number {
    case positive(Binary), negative(Binary), zero
    
    public init(integerLiteral: Int) {
        if integerLiteral == 0 {
            self = .zero
        } else {
            if integerLiteral > 0 {
                self = .positive(Binary(integerLiteral: abs(integerLiteral)))
            } else {
                self = .negative(Binary(integerLiteral: abs(integerLiteral)))
            }
        }
    }
    
    public static func build(_ value: Int) -> Number {
        return Number(integerLiteral: value)
    }
    
    public func incremented() -> Number {
        return self + Number(integerLiteral: 1)
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .zero:
            return "0"
        case .positive(let binary):
            return binary.description
        case .negative(let binary):
            return "-\(binary)"
        }
    }
}

extension Number: Comparable, Equatable {
    public static func < (lhs: Number, rhs: Number) -> Bool {
        switch (lhs, rhs) {
        case (.positive(let binary1), .positive(let binary2)):
            return binary1 < binary2
        case (.negative(let binary1), .negative(let binary2)):
            return binary1 > binary2
        case (.zero, .positive(_)),
             (.negative(_), _):
            return true
        case (.zero, _),
             (.positive(_), _):
            return false
        }
    }
    
    public static func ==(lhs: Number, rhs: Number) -> Bool {
        switch (lhs, rhs) {
        case (.positive(let binary1), .positive(let binary2)):
            return binary1 == binary2
        case (.negative(let binary1), .negative(let binary2)):
            return binary1 == binary2
        case (.zero, .zero):
            return true
        default:
            return false
        }
    }
}

extension Number {
    public static func -= (lhs: inout Number, rhs: Number) {
        lhs = lhs - rhs
    }
    
    public static func += (lhs: inout Number, rhs: Number) {
        lhs = lhs + rhs
    }
    
    public static func +(lhs: Number, rhs: Number) -> Number {
        switch (lhs, rhs) {
        case (.zero, let number),
             (let number, .zero):
            return number
        case (.positive(let number1), .negative(let number2)) where number1 > number2,
             (.negative(let number2), .positive(let number1)) where number1 > number2:
            return .positive(number1 - number2)
        case (.positive(let number1), .negative(let number2)) where number1 < number2,
             (.negative(let number2), .positive(let number1)) where number1 < number2:
            return .negative(number2 - number1)
        case (.positive(let number1), .negative(let number2)) where number1 == number2,
             (.negative(let number2), .positive(let number1)) where number1 == number2:
            return .zero
        case (.positive(let number1), .positive(let number2)):
            return .positive(number1 + number2)
        case (.negative(let number1), .negative(let number2)):
            return .negative(number1 + number2)
        default:
            assert(false)
        }
    }
    
    public static func -(lhs: Number, rhs:Number) -> Number {
        switch (lhs, rhs) {
        case (let number, .positive(let binary)):
            return number + .negative(binary)
        case (let number, .negative(let binary)):
            return number + .positive(binary)
        case (let number, .zero):
            return number
        }
    }
    
    public static func *(lhs: Number, rhs: Number) -> Number {
        switch (lhs, rhs) {
        case (.zero, _),
             (_, .zero):
            return .zero
        case (.positive(let binary1), .positive(let binary2)),
             (.negative(let binary1), .negative(let binary2)):
            return .positive(binary1 * binary2)
        case (.negative(let binary1), .positive(let binary2)),
             (.positive(let binary1), .negative(let binary2)):
            return .negative(binary1 * binary2)
        }
    }
}

extension Number: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
}
