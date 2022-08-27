//
//  String+Path.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension String {
    var pathComponents: [String] { return nsString.pathComponents }
    var isAbsolutePath: Bool { return nsString.isAbsolutePath }
    var lastPathComponent: String { return nsString.lastPathComponent }
    var deletingLastPathComponent: String { return nsString.deletingLastPathComponent }
    var pathExtension: String { return nsString.pathExtension }
    var deletingPathExtension: String { return nsString.deletingPathExtension }
    
    var parseQuery: [String: String] {
        var query = [String: String]()
        let pairs = self.components(separatedBy: "&")
        for pair in pairs {
            let elements = pair.components(separatedBy: "=")
            if elements.count == 2 {
                let qKey = elements[0].removingPercentEncoding ?? elements[0]
                let qValue = elements[1].removingPercentEncoding ?? elements[1]
                query[qKey] = qValue
            }
        }
        return query
    }
    
    static func path(withComponents components: [String]) -> String {
        return NSString.path(withComponents: components)
    }
    
    func appendingPathComponent(_ pathComponent: String?) -> String {
        guard let pathComponent = pathComponent else {
            return self
        }
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    func appendingPathExtension(_ pathExtension: String?) -> String {
        guard let pathExtension = pathExtension else {
            return self
        }
        return (self as NSString).appendingPathExtension(pathExtension) ?? self
    }
}
