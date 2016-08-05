//
//  NSAttributedString+Format.swift
//  bose-connect-ios
//
//  Created by Paul Rolfe on 1/16/16.
//  Copyright © 2016 Intrepid-Pursuits. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    /**
     Create a mutable attributed string with the attributes applied to all arguments.
     
     - parameter string:     formatted string where `%@` represents an argument.
     - parameter attributes: attributes dictionary to use on arguments
     - parameter args:       comma separated list of arguments
     
     - returns: NSMutableAttributedString with the attributes applied to argument strings.
     */
    public convenience init(stringWithFormat string: String, applyingAttributes attributes: [String : AnyObject], toArgs args: String...) {
        let formattedArgs = args.map { arg in
            return AttributedString(string: arg, attributes: attributes)
        }
        
        self.init(stringWithFormat: string, formattedArgs)
    }
    
    /**
     Create a mutable attributed string with the given list of NSAttributedString
     
     - parameter string: formatted string where `%@` represents an argument.
     - parameter args:   comma separated list of arguments (NSAttributedString)
     
     - returns: NSMutableAttributedString with arguments inserted according to format.
     */
     public convenience init(stringWithFormat string: String, _ args: AttributedString...) {
        self.init(stringWithFormat: string, args)
    }
    
    /**
     Create a mutable attributed string with the given collection of NSAttributedString
     
     - parameter string: formatted string where `%@` represents an argument.
     - parameter args:   comma separated list of arguments (NSAttributedString)
     
     - returns: NSMutableAttributedString with arguments inserted according to format.
     */
    public convenience init(stringWithFormat string: String, _ args: [AttributedString]) {
        let str = string as NSString
        self.init(string: string)
        var rangeLimit = NSMakeRange(0, str.length)
        var insertRange = str.range(of: "%@", options: .backwards, range: rangeLimit)
        args.reversed().forEach { arg in
            guard insertRange.location != NSNotFound else { return }
            self.replaceCharacters(in: insertRange, with: arg)
            rangeLimit = NSMakeRange(0, insertRange.location)
            insertRange = str.range(of: "%@", options: .backwards, range: rangeLimit)
        }
    }
}
