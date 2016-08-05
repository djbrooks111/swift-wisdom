//
//  NSData+Extensions.swift
//  bmap
//
//  Created by Logan Wright on 11/25/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation

public extension Data {
    // From here: http://stackoverflow.com/a/30415543/2611971
    public var ip_hexString: String? {
        guard count > 0 else { return nil }
        
        let  hexChars = Array("0123456789abcdef".utf8) as [UInt8]
        let bufer = UnsafeBufferPointer<UInt8>(start: UnsafePointer(bytes), count: count)
        var output = [UInt8](repeating: 0, count: (count * 2) + 1)
        var ix: Int = 0
        bufer.forEach {
            let hi  = Int(($0 & 0xf0) >> 4)
            let low = Int($0 & 0x0f)
            output[ix] = hexChars[hi]
            ix += 1
            output[ix] = hexChars[low]
            ix += 1
        }
        let result = String(cString: UnsafePointer(output))
        return result
    }
    
    public var ip_hexInt: UInt? {
        guard let hexString = ip_hexString else { return nil }
        return strtoul(hexString, nil, 16)
    }
    
    public var ip_intValue: Int? {
        var val: Int = 0
        getBytes(&val, length: sizeof(Int))
        return val
    }
    
    public var ip_uint8Value: UInt8? {
        var val: UInt8 = 0
        getBytes(&val, length: sizeof(UInt8))
        return val
    }
    
    public var ip_utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    public var ip_asciiString: String? {
        return String(data: self, encoding: String.Encoding.ascii)
    }
}

public extension Data {
    public subscript(idx: Int) -> Data? {
        guard count >= idx + 1 else { return nil }
        return subdata(in: NSMakeRange(idx, 1))
    }
}

public extension Data {
    /*
    Inclusive, ie: 1 will include index 1
    */
    public func ip_suffixFrom(_ startIdx: Int) -> Data? {
        let end = count - 1
        guard startIdx <= end else { return nil }
        return self[startIdx...end]
    }
    
    /*
    Inclusive, ie: 1 will include index 1
    */
    public func ip_prefixThrough(_ endIdx: Int) -> Data? {
        guard endIdx >= 0 else { return nil }
        return self[0...endIdx]
    }
}

public extension NSMutableData {
    public func ip_trimRange(_ range: Range<Int>) {
        let frontRange = range.lowerBound - 1
        let endRange = range.upperBound
        
        let prefix = ip_prefixThrough(frontRange) ?? Data()
        let suffix = ip_suffixFrom(endRange) ?? Data()
        
        length = 0
        append(prefix)
        append(suffix)
    }
}



extension Data {
    public func ip_chunks(ofLength length: Int, includeRemainder: Bool = true) -> [Data] {
        let range = 0..<length
        let mutable = NSData(data: self) as Data
        var chunks: [Data] = []
        while mutable.count >= length {
            guard let next = mutable[range] else { break }
            chunks.append(next)
            mutable.ip_trimRange(range)
        }
        
        if includeRemainder && mutable.count > 0 {
            let trailingData = NSData(data: mutable) as Data
            chunks.append(trailingData)
        }
        
        return chunks
    }
}

extension Data {
    public func ip_segmentGenerator(start: Int = 0, chunkLength: Int) -> AnyIterator<Data> {
        guard let segmentToWrite = ip_suffixFrom(start) else { return AnyIterator { return nil } }
        var mutable = NSData(data: segmentToWrite) as Data
        let range = 0..<chunkLength
        return AnyIterator {
            let nextData: Data?
            if mutable.count >= chunkLength {
                nextData = mutable[range]
                mutable.ip_trimRange(range)
            } else if mutable.count > 0 {
                nextData = NSData(data: mutable) as Data
                mutable.count = 0
            } else {
                nextData = nil
            }
            return nextData
        }
    }
}

extension Data {
    public func ip_subdataFrom(_ idx: Int, length: Int) -> Data? {
        return self[idx..<(idx + length)]
    }
}

extension Data {
    public init(byte: UInt8) {
        var _byte = byte
        (self as NSData).init(bytes: &_byte, length: sizeof(UInt8))
    }
}

extension NSMutableData {
    public func ip_appendByte(_ byte: UInt8) {
        var byte = byte
        append(&byte, length: sizeof(UInt8))
    }
    
    public func appendUTF8String(_ string: String) {
        guard let data = string.ip_utf8Data else { return }
        append(data as Data)
    }
}


extension Data {
    public subscript(range: Range<Int>) -> Data? {
        guard range.lowerBound >= 0 else { return nil }
        guard count >= range.upperBound else { return nil }
        let rangeLength = range.upperBound - range.lowerBound
        guard rangeLength > 0 else { return nil }
        let nsrange = NSMakeRange(range.lowerBound, rangeLength)
        return subdata(in: nsrange)
    }
}
