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
    
    static func isEmpty(_ string: String?, trimCharacters: CharacterSet = CharacterSet(charactersIn: "")) -> Bool {
        if (string == nil) { return true }
        return string!.trimmingCharacters(in: trimCharacters) == ""
    }
}

// MARK: - Index
public extension String {
    subscript (index: Int) -> String {
        let indexBy = indexOffset(index)
        guard indexBy < self.endIndex else { return "" }
        return String(self[indexBy])
    }
    
    func indexOffset(_ by: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: by)
    }
        
    func indexOf(target: String) -> Int {
        if let range = self.range(of: target) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return -1
    }
}

// MARK: - SubString
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
    
    func addSpaces(_ forMaxLenght: Int) -> String {
        if self.length >= forMaxLenght { return self }
        var result = self
        for _ in 0..<(forMaxLenght - self.length) {
            result.append(" ")
        }
        return result
    }
}


// MARK: - Numberic
public extension String {
    var int: Int? { return Int(self.deleteSub(",")) }
    var int64: Int64? { return Int64(self.deleteSub(",")) }
    var intValue: Int { return Int(self.deleteSub(",")) ?? 0 }
    var int64Value: Int64 { return Int64(self.deleteSub(",")) ?? 0 }
}

// MARK: - Date Time
public extension String {
    func toDate(formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
    
    func toDate(format dateFormat: String, locale: Locale? = nil, timeZone: TimeZone? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let locale = locale { dateFormatter.locale = locale }
        if let timeZone = timeZone { dateFormatter.timeZone = timeZone }
        return dateFormatter.date(from: self)
    }
    
    func toDateFormat8601() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func toDateFormatRFC3339() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}

// MARK: - Path
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

// MARK: - URL
public extension String {
    var encodeUrlPercentEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    func encodeUrl(_ characterSet: CharacterSet = .urlFragmentAllowed) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
    }
}

// MARK: - Range
public extension String {
    mutating func stringByDeleteCharactersInRange(_ range: NSRange) {
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(startIndex, offsetBy: range.length)
        self.removeSubrange(startIndex ..< endIndex)
    }
    
    func getRanges(of: String?) -> [NSRange]? {
        guard let ofString = of, String.isEmpty(ofString) == false else {
            return nil
        }
        
        do {
            let regex = try NSRegularExpression(pattern: ofString)
            return regex.matches(in: self, range: NSRange(location: 0, length: self.length)).map({ (textCheckingResult) -> NSRange in
                return textCheckingResult.range
            })
        } catch {
            let range = self.nsString.range(of: ofString)
            if range.location != NSNotFound {
                var ranges = [NSRange]()
                ranges.append(range)
                let remainString = self.nsString.substring(from: range.location + range.length)
                if let rangesNext = remainString.getRanges(of: ofString) {
                    ranges.append(contentsOf: rangesNext)
                }
                return ranges
            } else {
                return nil
            }
        }
    }
    
    func rangesOfString(_ ofString: String, options: NSString.CompareOptions = [], searchRange: Range<Index>? = nil ) -> [Range<Index>] {
        if let range = self.range(of: ofString, options: options, range: searchRange, locale: nil) {
            let nextRange: Range = range.upperBound..<self.endIndex
            return [range] + rangesOfString(ofString, searchRange: nextRange)
        }
        return []
    }
}

// MARK: - Validate
public extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailCheck.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var isValidUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return !String.isEmpty(url.scheme) && !String.isEmpty(url.host)
    }
}


// MARK: - Write to File
public extension String {
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
}

// MARK: Localization
public extension String {
    var localizedString: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
