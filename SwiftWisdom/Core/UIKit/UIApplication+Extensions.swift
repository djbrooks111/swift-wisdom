//
//  UIApplication+Extensions.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 1/19/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import UIKit

extension UIApplication {
    public func ip_openSettingsApp() {
        guard
            let url = URL(string: UIApplicationOpenSettingsURLString)
            , canOpenURL(url)
            else { fatalError("Unable to go to settings") }
        
        openURL(url)
    }
}
