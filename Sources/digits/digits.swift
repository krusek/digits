public typealias Binary = List<Digit>

public enum Digit {
    case zero, one
}

extension List: CustomStringConvertible where Element == Digit {
    public var description: String {
        switch self {
        case .empty:
            return ""
        case .list(.one, let tail):
            return "1" + tail.description
        case .list(.zero, let tail):
            return "0" + tail.description
        }
    }
}


extension List where Element == Digit {
    public static var zero: Binary {
        return .list(.zero, .empty)
    }
    
    public func incremented() -> Binary {
        switch self {
        case .empty:
            return .list(.one, .empty)
        case .list(.zero, let list):
            return .list(.one, list)
        case .list(.one, let list):
            return .list(.zero, list.incremented())
        }
    }
    
    public static func build(_ value: Int) -> Binary {
        var b = Binary.empty
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
            return .empty
        default:
            return .list(.zero, self)
        }
    }
    
    public func mod5(_ index: Int = 0, _ accumulator: Binary = .zero) -> Binary {
        let powers: [List<Digit>] = [
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
        case .empty where accumulator > List<Digit>.build(4):
            return accumulator.mod5()
        case .empty:
            return accumulator
        case .list(let d, let tail):
            return tail.mod5((index + 1) % 4, accumulator + d * powers[index % 4])
        }
    }
    
    public static func subtract(lhs: Binary, rhs: Binary, carrying: Bool = false) -> Binary {
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
            return .list(.one, subtract(lhs: tail, rhs: .empty, carrying: true))
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
            return reduce(lhs:.empty, rhs:tail, initial:f(.zero, d, initial), f:f)
        case (.list(let d, let tail), .empty):
            return reduce(lhs:tail, rhs:.empty, initial:f(d, .zero, initial), f:f)
        case (.list(let d, let ltail), .list(let e, let rtail)):
            return reduce(lhs: ltail, rhs: rtail, initial:f(d, e, initial), f:f)
        }
    }
}

extension List: Comparable, Equatable where Element == Digit {}

public func ==(lhs: Binary, rhs: Binary) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
        return true
    case (.list(.zero, let rtail), .list(.zero, let ltail)),
         (.list(.one, let rtail), .list(.one, let ltail)):
        return rtail == ltail
    case (.list(.zero, let tail), .empty),
         (.empty, .list(.zero, let tail)):
        return tail == .empty
    default:
        return false
    }
}

public func <(lhs: Binary, rhs: Binary) -> Bool {
    return Binary.reduce(lhs: lhs, rhs: rhs, initial: false) { (a, b, r) -> Bool in
        if a == b {
            return r
        } else {
            return a == .zero
        }
    }
}

public func +(lhs: Binary, rhs: Binary) -> Binary {
    switch (lhs, rhs) {
    case (.empty, let tail),
         (let tail, .empty):
        return tail
    case (.list(let e, let tail1), .list(.zero, let tail2)),
         (.list(.zero, let tail1), .list(let e, let tail2)):
        return .list(e, tail1 + tail2)
    case (.list(.one, let tail1), .list(.one, let tail2)):
        return .list(.zero, (tail1 + tail2).incremented())
    }
}

public func *(e: Digit, n: Binary) -> Binary {
    switch e {
    case .one:
        return n
    case .zero:
        return .zero
    }
}

public func *(lhs: Binary, rhs: Binary) -> Binary {
    switch (lhs, rhs) {
    case (.empty, _), (_, .empty):
        return .empty
    case (.list(let d, let tail), let rhs):
        return d * rhs + tail * rhs.shifted()
    }
}
