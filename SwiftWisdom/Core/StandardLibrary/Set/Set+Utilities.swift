
public func +=<T>(lhs: inout Set<T>, rhs: Set<T>) {
    lhs = lhs.union(rhs)
}

public func -=<T>(lhs: inout Set<T>, rhs: Set<T>) {
    lhs = lhs.subtracting(rhs)
}

public extension Set {
    public func ip_toArray() -> [Element] {
        return Array<Element>(self)
    }
    
    public func ip_passesTest(_ test: @noescape (element: Element) -> Bool) -> Bool {
        for ob in self {
            if test(element: ob) {
                return true
            }
        }
        return false
    }
    
    public func ip_filter(_ include: @noescape (element: Element) -> Bool) -> Set<Element> {
        var filtered = Set<Element>()
        for ob in self {
            if include(element: ob) {
                filtered.insert(ob)
            }
        }
        return filtered
    }
}
