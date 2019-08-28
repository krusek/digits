
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
