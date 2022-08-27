//
//  String+Extension.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension String {
    static let empty: String = ""

    var nsString: NSString { return self as NSString }
    var length: Int { return self.nsString.length }
    var trimWhiteSpace: String { return self.trimmingCharacters(in: .whitespaces) }
    var trimWhiteSpaceAndNewLine: String { return self.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    func indexOffset(_ by: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: by)∫
    }
    
    subscript (index: Int) -> String {
        let indexBy = indexOffset(index)
        guard indexBy < self.endIndex else { return "" }
        return String(self[indexBy])
    }
        
    func indexOf(target: String) -> Int {
        if let range = self.range(of: target) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    static func isEmpty(_ string: String?, trimCharacters: CharacterSet = CharacterSet(charactersIn: "")) -> Bool {
        if (string == nil) { return true }
        return string!.trimmingCharacters(in: trimCharacters) == ""
    }
    
    func getDynamicHeight(withFont: NSUIFont) -> CGFloat {
        return self.nsString.size(withAttributes: [NSAttributedString.Key.font: withFont]).height
    }
    
    mutating func stringByDeleteCharactersInRange(_ range: NSRange) {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        self.removeSubrange(startIndex ..< endIndex)
    }
            
    func addSpaces(_ forMaxLenght: Int) -> String {
        if self.length >= forMaxLenght { return self }
        var result = self
        for _ in 0..<(forMaxLenght - self.length) {
            result.append(" ")
        }
        return result
    }
    
    @discardableResult
    func writeToDocument(_ fileName: String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            //writing
            do {
                try self.write(to: fileURL, atomically: false, encoding: .utf8)
                return true
            } catch { /* error handling here */ }
        }
        return false
    }
        
    var localizedString: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
