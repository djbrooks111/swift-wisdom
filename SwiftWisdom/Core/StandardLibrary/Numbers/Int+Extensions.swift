//
//  Int+Extensions.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 1/19/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import Foundation

extension Integer {
    public var ip_isEven: Bool {
        return (self % 2) == 0
    }
    
    public var ip_isOdd: Bool {
        return !ip_isEven
    }
}

extension Integer {
    public func ip_times(_ closure: @escaping Block) {
        precondition(self >= 0)
        (0..<self).forEach { _ in closure() }
    }
}
