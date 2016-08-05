public extension Array {
    public func ip_subArrayFromIndices(_ indices: [Int]) -> [Element] {
        var subArray: [Element] = []
        for (idx, element) in enumerated() {
            if indices.contains(idx) {
                subArray.append(element)
            }
        }
        return subArray
    }

    public func ip_passesTest(_ test: @noescape (element: Element) -> Bool) -> Bool {
        for ob in self {
            if test(element: ob) {
                return true
            }
        }
        return false
    }
}

public extension Array where Element: Equatable {
    public mutating func ip_remove(_ objectToRemove: Element) -> Bool {
        for (idx, objectToCompare) in enumerated() where objectToRemove == objectToCompare {
            remove(at: idx)
            return true
        }
        return false
    }
}

public extension Array where Element: Hashable {
    public func ip_toSet() -> Set<Element> {
        return Set(self)
    }
}

extension Array {
    public subscript(ip_safe safe: Int) -> Element? {
        guard 0 <= safe && safe < count else { return nil }
        return self[safe]
    }
}

extension Array {
    public mutating func ip_removeFirst(_ matcher: @noescape (Iterator.Element) -> Bool) {
        guard let idx = index(where: matcher) else { return }
        remove(at: idx)
    }
}

extension Array {
    public var ip_generator: AnyIterator<Element> {
        var idx = 0
        let count = self.count
        return AnyIterator {
            guard idx < count else { return nil }
            let this = idx
            idx += 1
            return self[this]
        }
    }
}

extension Collection {
    /// This grabs the element(s) in the middle of the array without doing any sorting.
    /// If there's an odd number the return array is just one element.
    /// If there are an even number it will return the two middle elements.
    public var ip_middleElements: [Iterator.Element] {
        guard count > 0 else { return [] }
        let needsAverageOfTwo = count.toIntMax().ip_isEven
        let middle = index.index(startIndex, offsetBy: count / 2)
        if needsAverageOfTwo {
            let leftOfMiddle = index.index(startIndex, offsetBy: (count / 2) - 1)
            return [self[middle], self[leftOfMiddle]]
        } else {
            return [self[middle]]
        }
    }
}

extension Sequence where Iterator.Element: Equatable {
    public func ip_mostCommonElements() -> [Iterator.Element] {
        let sortedUniqueElements = self.ip_uniqueValues().sorted {
                self.ip_countOf($0) > self.ip_countOf($1)
            }
        guard let first = sortedUniqueElements.first else { return [] }
        return sortedUniqueElements.lazy.filter {
            self.ip_countOf(first) == self.ip_countOf($0)
        }
    }
        
    public func ip_uniqueValues() -> [Iterator.Element] {
        var buffer: [Iterator.Element] = []
        forEach { element in
            if !buffer.contains(element) {
                buffer.append(element)
            }
        }
        return buffer
    }
    
    public func ip_countOf(_ element: Iterator.Element) -> Int {
        return self.filter { $0 == element } .count
    }
}
