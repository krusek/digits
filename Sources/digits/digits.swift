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
}

extension List: Equatable where Element == Digit {}

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
