//
//  DoubleTests.swift
//  SwiftWisdom
//
//  Created by Stephen Wong on 5/1/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import XCTest
import SwiftWisdom

class DoubleTests: XCTestCase {

    func testRounding() {
        let unroundedDoubles = [M_PI, 5.0156, 10.014, 9999.99499]
        let roundedToOneDecimalPlaces = [3.1, 5.0, 10.0, 10000.0]
        let roundedToTwoDecimalPlaces = [3.14, 5.02, 10.01, 9999.99]
        let roundedToFiveDecimalPlaces = [3.14159, 5.0156, 10.014, 9999.99499]
        
        for (index, unroundedDouble) in unroundedDoubles.enumerate() {
            XCTAssertEqual(unroundedDouble.ip_roundToDecimalPlaces(1), roundedToOneDecimalPlaces[index])
            XCTAssertEqual(unroundedDouble.ip_roundToDecimalPlaces(2), roundedToTwoDecimalPlaces[index])
            XCTAssertEqual(unroundedDouble.ip_roundToDecimalPlaces(5), roundedToFiveDecimalPlaces[index])
        }
        
    }
}
