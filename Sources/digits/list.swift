
public indirect enum List<Element> {
    case empty, list(Element, List<Element>)
    
    public static func build(_ elements: Element...) -> List<Element> {
        var l = List<Element>.empty
        for e in elements.reversed() {
            l = e + l
        }
        return l
    }
    
    public func reversed() -> List<Element> {
        switch self {
        case .empty,
             .list(_, .empty):
            return self
        case .list(let d, let tail):
            return tail.reversed() + d
        }
    }
}

public func +<Element>(lhs: List<Element>, rhs: Element) -> List<Element> {
    switch lhs {
    case .empty:
        return .list(rhs, .empty)
    case .list(let d, let tail):
        return .list(d, tail + rhs)
    }
}

public func +<Element>(lhs: Element, rhs: List<Element>) -> List<Element> {
    return .list(lhs, rhs)
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
