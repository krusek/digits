
public indirect enum List<Element> {
    case empty, list(Element, List<Element>)
    
    public static func build(_ elements: Element...) -> List<Element> {
        var l = List<Element>.empty
        for e in elements.reversed() {
            l = e + l
        }
        return l
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
    case (.list(.zero, let tail), .empty):
        return tail == .empty
    default:
        return false
    }
}
