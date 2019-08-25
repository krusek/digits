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
            return tail.description + "1"
        case .list(.zero, let tail):
            return tail.description + "0"
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
                b = .one + b
                v -= 1
                v = v / 2
            } else {
                b = .zero + b
                v = v / 2
            }
        }
        return b.reversed()
    }
}

extension List: Equatable where Element == Digit {}

public func ==(lhs: List<Digit>, rhs: List<Digit>) -> Bool {
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
