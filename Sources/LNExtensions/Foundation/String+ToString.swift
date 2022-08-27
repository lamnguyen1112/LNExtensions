//
//  String+SubString.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension String {
    func substring(from: Int) -> String? {
        guard from >= 0 else { return nil }
        return nsString.substring(from: from)
    }
    
    func substring(to: Int) -> String? {
        guard to >= 0, to < nsString.length else { return nil }
        return nsString.substring(to: to)
    }
    
    func substring(from: Int, to: Int) -> String? {
        guard from >= 0, to >= 0, to > from, to <= nsString.length else { return nil }
        return nsString.substring(with: NSMakeRange(from, to - from))
    }
    
    func stringByDeletePrefix(_ prefix: String?) -> String {
        if let prefixString = prefix, self.hasPrefix(prefixString) {
            return self.nsString.substring(from: prefixString.length)
        }
        return self
    }
    
    func stringByDeleteSuffix(_ suffix: String?) -> String {
        if let suffixString = suffix, self.hasSuffix(suffixString) {
            return self.nsString.substring(to: self.length - suffixString.length)
        }
        return self
    }
    
    func deleteSuffix(_ suffix: Int) -> String {
        if suffix >= self.length {
            return self
        }
        return self.nsString.substring(to: self.length - suffix)
    }
    
    func deleteSub(_ subStringToDelete: String) -> String {
        return self.replacingOccurrences(of: subStringToDelete, with: "")
    }
}
