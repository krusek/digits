public indirect enum BinaryInteger {
    case list(Digit, BinaryInteger), empty(Sign)
}

public enum Digit {
    case zero, one
}

public enum Sign {
    case positive, negative

    fileprivate var digit: Digit {
        switch self {
        case .positive:
            return .zero
        case .negative:
            return .one
        }
    }
}

extension BinaryInteger: CustomStringConvertible {
    public var description: String {
        return self.toString(radix: 10)
    }

    public func toString(radix: Int) -> String {
        guard self != .zero else { return "0" }
        guard self > .zero else {
            return "-\(self.negated())"
        }

        let rb = BinaryInteger.build(radix)
        var value = self
        var remainder = BinaryInteger.zero
        var r = ""
        while value != .zero {
            (value, remainder) = try! BinaryInteger.positiveIntegerDivide(divisor: rb, dividend: value)
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
        return .empty(.positive)
    }

    public var isZero: Bool {
        return self.isZeros
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

    public func decremented() -> BinaryInteger {
        switch self {
        case .list(.one, let list):
            return .list(.zero, list)
        case .list(.zero, let list):
            return .list(.one, list.decremented())
        case .empty(.positive):
            return .empty(.negative)
        case .empty(.negative):
            return .list(.zero, .empty(.negative))
        }
    }

    public static func build(_ value: Int) -> BinaryInteger {
        var b = BinaryInteger.empty(.positive)
        var v = abs(value)
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
        if value < 0 {
            return (~r + .one).trim()
        } else {
            return r
        }
    }

    private func trim() -> BinaryInteger {
        switch self {
        case .list(.one, .empty(.negative)):
            return .empty(.negative);
        case .list(.zero, .empty(.positive)):
            return .empty(.positive)
        case .list(let d, let tail):
            return .list(d, tail.trim())
        case .empty(_):
            return self
        }
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

public enum ArithmeticError: Error {
    case divideByZero
}

extension BinaryInteger: Equatable, Comparable {

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

    public static func < (lhs: BinaryInteger, rhs: BinaryInteger) -> Bool {
        guard !lhs.isZero || !rhs.isZero else { return false }

        let lsign = lhs.sign
        let rsign = rhs.sign

        print("\(lsign), \(rsign)")
        if lsign != rsign {
            return lsign == .negative
        }

        let labs = lsign == .positive ? lhs : lhs.negated()
        let rabs = rsign == .positive ? rhs : rhs.negated()

        let temp = BinaryInteger.reduce(lhs: labs, rhs: rabs, initial: false) { (a, b, r) -> Bool in
            if a == b {
                return r
            } else {
                return a == .zero
            }
        }
        return lsign == .positive ? temp : !temp
    }


    fileprivate static func reduce<Result>(lhs: BinaryInteger, rhs: BinaryInteger, initial: Result, f: (Digit, Digit, Result) -> Result) -> Result {
        switch (lhs, rhs) {
        case (.empty(let value1), .empty(let value2)):
            return f(value1.digit, value2.digit, initial)
        case (.empty(let sign), .list(let d, let tail)):
            return reduce(lhs:lhs, rhs:tail, initial:f(sign.digit, d, initial), f:f)
        case (.list(let d, let tail), .empty(let sign)):
            return reduce(lhs:tail, rhs:rhs, initial:f(d, sign.digit, initial), f:f)
        case (.list(let d, let ltail), .list(let e, let rtail)):
            return reduce(lhs: ltail, rhs: rtail, initial:f(d, e, initial), f:f)
        }
    }
}

extension BinaryInteger: AdditiveArithmetic {
    public static func += (lhs: inout BinaryInteger, rhs: BinaryInteger) {
        lhs = lhs + rhs
    }

    public static func -= (lhs: inout BinaryInteger, rhs: BinaryInteger) {
        lhs = lhs - rhs
    }

    private var sign: Sign {
        switch self {
        case .empty(let sign):
            return sign
        case .list(_, let tail):
            return tail.sign
        }
    }

    public static prefix func ~(lhs: BinaryInteger) -> BinaryInteger {
        switch lhs {
        case .empty(.positive):
            return .empty(.negative)
        case .empty(.negative):
            return .empty(.positive)
        case .list(.one, let tail):
            return .list(.zero, ~tail)
        case .list(.zero, let tail):
            return .list(.one, ~tail)
        }
    }

    public static func -(lhs: BinaryInteger, rhs: BinaryInteger) -> BinaryInteger {
        return lhs + ~rhs + .one
    }

    public static func +(lhs: BinaryInteger, rhs: BinaryInteger) -> BinaryInteger {
        switch (lhs, rhs) {
        case (.empty(.positive), let tail),
             (let tail, .empty(.positive)):
            return tail
        case (.empty(.negative), .empty(.negative)):
            return .list(.zero, .empty(.negative))
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

extension BinaryInteger {
    public static func *(e: Digit, n: BinaryInteger) -> BinaryInteger {
        switch e {
        case .one:
            return n
        case .zero:
            return .zero
        }
    }

    private func shifted() -> BinaryInteger {
        return .list(.zero, self)
    }

    private func negated() -> BinaryInteger {
        return ~self + .one
    }

    public static func *(lhs: BinaryInteger, rhs: BinaryInteger) -> BinaryInteger {
        let lsign = lhs.sign
        let rsign = rhs.sign

        let labs = (lsign == .positive) ? lhs : lhs.negated()
        let rabs = (rsign == .positive) ? rhs : rhs.negated()

        let fsign: Sign = lsign == rsign ? .positive : .negative

        let mabs = positiveMultiply(lhs: labs, rhs: rabs)
        return (fsign == .positive) ? mabs : mabs.negated()
    }

    private static func positiveMultiply(lhs: BinaryInteger, rhs: BinaryInteger) -> BinaryInteger {
        switch (lhs, rhs) {
        case (.empty(_), _), (_, .empty(_)):
            return .empty(.positive)
        case (.list(let d, let tail), let rhs):
            return d * rhs + tail * rhs.shifted()
        }
    }

    public static func /(dividend: BinaryInteger, divisor: BinaryInteger) throws -> BinaryInteger {
        guard divisor != .zero else { throw ArithmeticError.divideByZero }
        guard dividend != .zero else { return .zero }

        let q: BinaryInteger
        switch (divisor.sign, dividend.sign) {
        case (.positive, .positive):
            (q, _) = try BinaryInteger.positiveIntegerDivide(divisor: divisor, dividend: dividend)
            return q
        case (.negative, .negative):
            (q, _) = try BinaryInteger.positiveIntegerDivide(divisor: divisor.negated(), dividend: dividend.negated())
            return q
        case (.positive, .negative):
            (q, _) = try BinaryInteger.positiveIntegerDivide(divisor: divisor, dividend: dividend.negated())
            return q.negated()
        case (.negative, .positive):
            (q, _) = try BinaryInteger.positiveIntegerDivide(divisor: divisor.negated(), dividend: dividend)
            return q.negated()
        }
    }

    public static func %(dividend: BinaryInteger, divisor: BinaryInteger) throws -> BinaryInteger {
        switch (divisor.sign, dividend.sign) {
        case (.positive, .positive):
            let (_, r) = try BinaryInteger.positiveIntegerDivide(divisor: divisor, dividend: dividend)
            return r
        case (.negative, .negative):
            let (_, r) = try BinaryInteger.positiveIntegerDivide(divisor: divisor.negated(), dividend: dividend.negated())
            return r
        case (.positive, .negative):
            let (_, r) = try BinaryInteger.positiveIntegerDivide(divisor: divisor, dividend: dividend.negated())
            return r.negated()
        case (.negative, .positive):
            let (_, r) = try BinaryInteger.positiveIntegerDivide(divisor: divisor.negated(), dividend: dividend)
            return r
        }
    }

    private static func partialDivide(divisor: BinaryInteger, dividend: BinaryInteger) throws -> (quotient: BinaryInteger, remainder: BinaryInteger) {
        guard divisor != .zero else { throw ArithmeticError.divideByZero }
        if divisor > dividend { return (quotient: .zero, remainder: dividend) }
        if divisor == dividend { return (quotient: .one, remainder: .zero) }

        var product = divisor
        var power = BinaryInteger.one
        while Digit.zero + product <= dividend {
            product = Digit.zero + product
            power = Digit.zero + power
        }
        return (quotient: power, remainder: dividend - product)
    }

    public static func positiveIntegerDivide(divisor: BinaryInteger, dividend: BinaryInteger) throws -> (quotient: BinaryInteger, remainder: BinaryInteger) {
        if divisor == .zero { throw ArithmeticError.divideByZero }

        var quotient = BinaryInteger.zero
        var remainder = dividend

        var (power, r) = try partialDivide(divisor: divisor, dividend: remainder)
        while power != .zero {
            quotient += power
            remainder = r
            (power, r) = try partialDivide(divisor: divisor, dividend: remainder)
        }

        return (quotient: quotient, remainder: remainder)
    }

    public func pow(_ power: BinaryInteger, partial: BinaryInteger = .one) -> BinaryInteger {
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
