//
//  RawRepresentable.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 3/31/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue: Integer {
    public static var ip_allCases: [Self] {
        var caseIndex: RawValue = RawValue.allZeros//RawValue.init(0)
        let generator: () -> Self? = {
            let next = Self.init(rawValue: caseIndex)
            caseIndex = <#T##Collection corresponding to `caseIndex`##Collection#>.index(after: caseIndex)
            return next
        }
        let sequence = AnyIterator(body: generator)
        return [Self](sequence)
    }
}
