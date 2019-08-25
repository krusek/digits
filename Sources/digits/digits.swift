
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
    public static var zero: List<Digit> {
        return .list(.zero, .empty)
    }
    
    public func incremented() -> List<Digit> {
        switch self {
        case .empty:
            return .list(.one, .empty)
        case .list(.zero, let list):
            return .list(.one, list)
        case .list(.one, let list):
            return .list(.zero, list.incremented())
        }
    }
}
