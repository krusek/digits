public typealias Binary = List<Digit, Void>

public indirect enum BinaryInteger {
    case list(Digit, BinaryInteger), empty(Sign)
}

public enum Digit {
    case zero, one
}

public enum Sign {
    case positive, negative
}

extension BinaryInteger: CustomStringConvertible {
    public var description: String {
        if self.isZero { return "0..." }
        switch self {
        case .list(.zero, let tail):
            return "0" + tail.description
        case .list(.one, let tail):
            return "1" + tail.description
        case .empty(.positive):
            return "0..."
        case .empty(.negative):
            return "1..."
        }
    }
}

extension List: CustomStringConvertible where Element == Digit, Empty == Void {
    public var description: String {
        return base10()
    }
    
    func base10() -> String {
        return toString(radix: 10)
    }
    
    public func toString(radix: Int) -> String {
        guard self != .zero else { return "0" }
        
        let rb = Binary.build(radix)
        var value = self
        var remainder = Binary.zero
        var r = ""
        while value != .zero {
            (value, remainder) = try! Binary.integerDivide(divisor: rb, dividend: value)
            r = remainder.digit(radix: radix) + r
        }
        return r
        
    }
    
    private func digit(radix: Int) -> String {
        for ix in 0..<10 {
            if self == .build(ix) {
                return String(ix, radix: radix)
            }
        }
        return ""
    }
}

extension BinaryInteger {
    public static var zero: BinaryInteger {
        return .list(.zero, .empty(.positive))
    }

    public var isZero: Bool {
        return self.isZeros || self.isOnes
    }

    private var isOnes: Bool {
        switch self {
        case .list(.zero, _):
            return false
        case .list(.one, let tail):
            return tail.isOnes
        case .empty(let sign):
            return sign == .negative
        }
    }

    private var isZeros: Bool {
        switch self {
        case .list(.one, _):
            return false
        case .list(.zero, let tail):
            return tail.isZeros
        case .empty(let sign):
            return sign == .positive
        }
    }

    public static var one: BinaryInteger {
        return .list(.one, .empty(.positive))
    }

    public func incremented() -> BinaryInteger {
        switch self {
        case .list(.zero, let list):
            return .list(.one, list)
        case .list(.one, let list):
            return .list(.zero, list.incremented())
        case .empty(.positive):
            return .list(.one, .empty(.positive))
        case .empty(.negative):
            return .list(.zero, .empty(.positive))
        }
    }

    public static func build(_ value: Int) -> BinaryInteger {
        var b = BinaryInteger.empty(.positive)
        var v = value
        while v > 0 {
            if v % 2 == 1 {
                b = .list(.one, b)
                v -= 1
                v = v / 2
            } else {
                b = .list(.zero, b)
                v = v / 2
            }
        }
        let r = b.reversed()
        return r
    }

    private func reversed() -> BinaryInteger {
        switch self {
        case .list(let d, let tail):
            return tail.reversed() + d
        default:
            return self
        }
    }


    public static func +(lhs: BinaryInteger, rhs: Digit) -> BinaryInteger {
        switch lhs {
        case .list(let d, let tail):
            return .list(d, tail + rhs)
        case .empty(_):
            return .list(rhs, lhs)
        }
    }

    public static func +(lhs: Digit, rhs: BinaryInteger) -> BinaryInteger {
        return .list(lhs, rhs)
    }
}

extension List where Element == Digit, Empty == Void {
    public static var zero: Binary {
        return .list(.zero, .empty(()))
    }
    
    public static var one: Binary {
        return .list(.one, .empty(()))
    }
    
    public func incremented() -> Binary {
        switch self {
        case .list(.zero, let list):
            return .list(.one, list)
        case .list(.one, let list):
            return .list(.zero, list.incremented())
        default:
            return .list(.one, self)
        }
    }
    
    public static func build(_ value: Int) -> Binary {
        var b = Binary.empty(())
        var v = value
        while v > 0 {
            if v % 2 == 1 {
                b = .list(.one, b)
                v -= 1
                v = v / 2
            } else {
                b = .list(.zero, b)
                v = v / 2
            }
        }
        let r = b.reversed()
        return r
    }
    
    func shifted() -> Binary {
        switch self {
        case .empty:
            return .empty(())
        default:
            return .list(.zero, self)
        }
    }
    
    public func mod5(_ index: Int = 0, _ accumulator: Binary = .zero) -> Binary {
        let powers: [Binary] = [
            .build(1), // 1 % 5 = 1
            .build(2), // 2 % 5 = 2
            .build(4), // 4 % 5 = 4
            .build(3)  // 8 % 5 = 3
        ]
        if self == .build(5) && index == 0 && accumulator == .zero { return .build(0) }
        if self == .build(6) && index == 0 && accumulator == .zero { return .build(1) }
        if self == .build(7) && index == 0 && accumulator == .zero { return .build(2) }
        if self == .build(8) && index == 0 && accumulator == .zero { return .build(3) }
        if self == .build(9) && index == 0 && accumulator == .zero { return .build(4) }
        if self == .build(10) && index == 0 && accumulator == .zero { return .build(0) }
        switch self {
        case .empty where accumulator == Binary.build(5):
            return .zero
        case .empty where accumulator > Binary.build(4):
            return accumulator.mod5()
        case .empty:
            return accumulator
        case .list(let d, let tail):
            return tail.mod5((index + 1) % 4, accumulator + d * powers[index % 4])
        }
    }
    
    fileprivate static func subtract(lhs: Binary, rhs: Binary, carrying: Bool = false) -> Binary {
        switch (lhs, rhs) {
        case (.list(.one, let tail1), .list(.one, let tail2)) where carrying,
             (.list(.zero, let tail1), .list(.zero, let tail2)) where carrying:
            return .list(.one, subtract(lhs: tail1, rhs: tail2, carrying: true))
        case (.list(.one, let tail1), .list(.one, let tail2)),
             (.list(.zero, let tail1), .list(.zero, let tail2)),
             (.list(.one, let tail1), .list(.zero, let tail2)) where carrying:
            return .list(.zero, subtract(lhs: tail1, rhs: tail2, carrying: false))
        case (.list(.one, let tail1), .list(.zero, let tail2)):
            return .list(.one, subtract(lhs: tail1, rhs: tail2, carrying: false))
        case (.list(.one, let tail), .empty) where carrying:
            return .list(.zero, tail)
        case (.list(.zero, let tail1), .list(.one, let tail2)):
            return .list(carrying ? .zero : .one, subtract(lhs: tail1, rhs: tail2, carrying: true))
        case (.list(.zero, let tail), .empty) where carrying:
            return .list(.one, subtract(lhs: tail, rhs: .empty(()), carrying: true))
        case (.list(.zero, _), .empty),
             (.list(.one, _), .empty),
             (.empty, _):
            return lhs
        }
    }
    
    fileprivate static func reduce<Result>(lhs: Binary, rhs: Binary, initial: Result, f: (Digit, Digit, Result) -> Result) -> Result {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return f(.zero, .zero, initial)
        case (.empty, .list(let d, let tail)):
            return reduce(lhs:.empty(()), rhs:tail, initial:f(.zero, d, initial), f:f)
        case (.list(let d, let tail), .empty):
            return reduce(lhs:tail, rhs:.empty(()), initial:f(d, .zero, initial), f:f)
        case (.list(let d, let ltail), .list(let e, let rtail)):
            return reduce(lhs: ltail, rhs: rtail, initial:f(d, e, initial), f:f)
        }
    }

    public func pow(_ power: Binary, partial: Binary = .one) -> Binary {
        switch power {
        case .empty:
            return partial
        case .list(.one, let tail):
            return (self * self).pow(tail, partial: partial * self)
        case .list(.zero, let tail):
            return (self * self).pow(tail, partial: partial)
        }
    }
}

extension List: ExpressibleByIntegerLiteral where Element == Digit, Empty == Void {
    public init(integerLiteral value: Int) {
        var b = Binary.empty(())
        var v = value
        while v > 0 {
            if v % 2 == 1 {
                b = .list(.one, b)
                v -= 1
                v = v / 2
            } else {
                b = .list(.zero, b)
                v = v / 2
            }
        }
        let r = b.reversed()
        self = r
    }
    
    public typealias IntegerLiteralType = Int
}

public enum ArithmeticError: Error {
    case divideByZero
}

extension List: AdditiveArithmetic where Element == Digit, Empty == Void {
    public static func += (lhs: inout Binary, rhs: Binary) {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout Binary, rhs: Binary) {
        lhs = lhs - rhs
    }
    
    public static func -(lhs: Binary, rhs: Binary) -> Binary {
        return Binary.subtract(lhs: lhs, rhs: rhs)
    }
}

extension BinaryInteger: Equatable {
    public static func ==(lhs: BinaryInteger, rhs: BinaryInteger) -> Bool {
        switch (lhs.isZero, rhs.isZero) {
        case (true, true):
            return true
        case (false, false):
            return listEquality(lhs: lhs, rhs: rhs)
        default:
            return false
        }
    }

    private static func listEquality(lhs: BinaryInteger, rhs:BinaryInteger) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.list(.zero, let rtail), .list(.zero, let ltail)),
             (.list(.one, let rtail), .list(.one, let ltail)):
            return rtail == ltail
        case (.list(.zero, let tail), .empty(.positive)),
             (.empty(.positive), .list(.zero, let tail)):
            return tail == .empty(.positive)
        case (.list(.one, let tail), .empty(.negative)),
             (.empty(.negative), .list(.one, let tail)):
            return tail == .empty(.negative)
        default:
            return false
        }
    }
}

extension List: Comparable, Equatable where Element == Digit, Empty == Void {
    public static func ==(lhs: Binary, rhs: Binary) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.list(.zero, let rtail), .list(.zero, let ltail)),
             (.list(.one, let rtail), .list(.one, let ltail)):
            return rtail == ltail
        case (.list(.zero, let tail), .empty),
             (.empty, .list(.zero, let tail)):
            return tail == .empty(())
        default:
            return false
        }
    }
    
    public static func <(lhs: Binary, rhs: Binary) -> Bool {
        return Binary.reduce(lhs: lhs, rhs: rhs, initial: false) { (a, b, r) -> Bool in
            if a == b {
                return r
            } else {
                return a == .zero
            }
        }
    }
}

extension BinaryInteger {
    public static func +(lhs: BinaryInteger, rhs: BinaryInteger) -> BinaryInteger {
        switch (lhs, rhs) {
        case (.empty(.positive), let tail),
             (let tail, .empty(.positive)):
            return tail
        case (.empty(.negative), let tail),
             (let tail, .empty(.negative)):
            return .list(.one, .empty(.negative)) + tail
        case (.list(let e, let tail1), .list(.zero, let tail2)),
             (.list(.zero, let tail1), .list(let e, let tail2)):
            return .list(e, tail1 + tail2)
        case (.list(.one, let tail1), .list(.one, let tail2)):
            return .list(.zero, (tail1 + tail2).incremented())
        }
    }
}

extension List where Element == Digit, Empty == Void {
    public static func +(lhs: Binary, rhs: Binary) -> Binary {
        switch (lhs, rhs) {
        case (.empty, let tail),
             (let tail, .empty(())):
            return tail
        case (.list(let e, let tail1), .list(.zero, let tail2)),
             (.list(.zero, let tail1), .list(let e, let tail2)):
            return .list(e, tail1 + tail2)
        case (.list(.one, let tail1), .list(.one, let tail2)):
            return .list(.zero, (tail1 + tail2).incremented())
        }
    }

    public static func *(e: Digit, n: Binary) -> Binary {
        switch e {
        case .one:
            return n
        case .zero:
            return .zero
        }
    }

    public static func *(lhs: Binary, rhs: Binary) -> Binary {
        switch (lhs, rhs) {
        case (.empty, _), (_, .empty):
            return .empty(())
        case (.list(let d, let tail), let rhs):
            return d * rhs + tail * rhs.shifted()
        }
    }
    
    private static func partialDivide(divisor: Binary, dividend: Binary) throws -> (quotient: Binary, remainder: Binary) {
        guard divisor != .zero else { throw ArithmeticError.divideByZero }
        if divisor > dividend { return (quotient: .zero, remainder: dividend) }
        if divisor == dividend { return (quotient: .one, remainder: .zero) }
        
        var product = divisor
        var power = Binary.one
        while Digit.zero + product <= dividend {
            product = Digit.zero + product
            power = Digit.zero + power
        }
        return (quotient: power, remainder: dividend - product)
    }
    
    public static func integerDivide(divisor: Binary, dividend: Binary) throws -> (quotient: Binary, remainder: Binary) {
        if divisor == .zero { throw ArithmeticError.divideByZero }
        
        var quotient = Binary.zero
        var remainder = dividend
        
        var (power, r) = try partialDivide(divisor: divisor, dividend: remainder)
        while power != .zero {
            quotient += power
            remainder = r
            (power, r) = try partialDivide(divisor: divisor, dividend: remainder)
        }
        
        return (quotient: quotient, remainder: remainder)
    }
}
