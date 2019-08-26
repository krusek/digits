public typealias Number = List<Digit>

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
    public static var zero: Number {
        return .list(.zero, .empty)
    }
    
    public func incremented() -> Number {
        switch self {
        case .empty:
            return .list(.one, .empty)
        case .list(.zero, let list):
            return .list(.one, list)
        case .list(.one, let list):
            return .list(.zero, list.incremented())
        }
    }
    
    public static func build(_ value: Int) -> Number {
        var b = Number.empty
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
    
    func shifted() -> Number {
        switch self {
        case .empty:
            return .empty
        default:
            return .list(.zero, self)
        }
    }
    
    
    fileprivate static func reduce<Result>(lhs: Number, rhs: Number, initial: Result, f: (Digit, Digit, Result) -> Result) -> Result {
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

public func ==(lhs: Number, rhs: Number) -> Bool {
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

public func <(lhs: Number, rhs: Number) -> Bool {
    return Number.reduce(lhs: lhs, rhs: rhs, initial: false) { (a, b, r) -> Bool in
        if a == b {
            return r
        } else {
            return a == .zero
        }
    }
}

public func +(lhs: Number, rhs: Number) -> Number {
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

public func *(e: Digit, n: Number) -> Number {
    switch e {
    case .one:
        return n
    case .zero:
        return .zero
    }
}

public func *(lhs: Number, rhs: Number) -> Number {
    switch (lhs, rhs) {
    case (.empty, _), (_, .empty):
        return .empty
    case (.list(let d, let tail), let rhs):
        return d * rhs + tail * rhs.shifted()
    }
}
