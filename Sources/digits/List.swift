
public indirect enum List<Element, Empty> {
    case empty(Empty), list(Element, List<Element, Empty>)
    
    public static func build(_ elements: Element...) -> List<Element, Void> {
        var l = List<Element, Void>.empty(())
        for e in elements.reversed() {
            l = e + l
        }
        return l
    }
    
    public func reversed() -> List<Element, Empty> {
        switch self {
        case .list(let d, let tail):
            return tail.reversed() + d
        default:
            return self
        }
    }
}

public func +<Element, Empty>(lhs: List<Element, Empty>, rhs: Element) -> List<Element, Empty> {
    switch lhs {
    case .list(let d, let tail):
        return .list(d, tail + rhs)
    case .empty(_):
        return .list(rhs, lhs)
    }
}

public func +<Element, Empty>(lhs: Element, rhs: List<Element, Empty>) -> List<Element, Empty> {
    return .list(lhs, rhs)
}
