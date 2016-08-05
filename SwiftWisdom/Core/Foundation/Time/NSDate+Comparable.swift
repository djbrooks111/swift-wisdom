//
//  Comparables.swift
//
//  Created by Logan Wright on 10/25/15.
//  Copyright © 2015 lowriDevs. All rights reserved.
//

import Foundation

extension Date : Comparable {}

public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
public func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
