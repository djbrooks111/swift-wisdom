//
//  UITableView+Extensions.swift
//  SwiftWisdom
//
//  Created by Alexander Persian on 9/8/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import UIKit

extension UITableView {
    /**
     Allows you to dynamically update a tableview's footer after it has initally been drawn. (Width is not needed since footers are always the full width of the tableview)

     - parameter footerView: View that will be used in the footer
     - parameter height:     Height of the footer within the tableview
     */
    public func ip_updateFooter(withView view: UIView, ofHeight height: CGFloat) {
        self.tableFooterView = nil // Ensure that old views are not left over or stacked on top of each other

        let footerContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.ip_width, height: height)) // Footers are always the width of the table view
        self.tableFooterView = footerContainer
        footerContainer.addSubview(view)
        footerContainer.constrainViewToAllEdges(view)
    }
}
