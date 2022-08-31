//
//  Numberic+Extension.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension SignedNumeric where Self: Comparable {
    var abs: Self { Swift.abs(self) }
}

public extension SignedInteger where Self: FixedWidthInteger {
    func toValue<T: SignedNumeric>() -> T where T: FixedWidthInteger {
        return T(self)
    }
}

public extension SignedNumeric where Self: LosslessStringConvertible {
    func toString(style: NumberFormatter.Style = .decimal,
                  groupSeparator: String? = nil,
                  decimalSeparator: String? = nil,
                  minFractionDigits: Int? = nil,
                  maxFractionDigits: Int? = nil,
                  locale: Locale? = nil) -> String {
        let format = NumberFormatter()
        format.numberStyle = style
        if let gSeparator = groupSeparator {
            format.groupingSeparator = gSeparator
            format.usesGroupingSeparator = true
        }
        if let dSeparator = decimalSeparator { format.decimalSeparator = dSeparator }
        if let min = minFractionDigits { format.minimumFractionDigits = min }
        if let max = maxFractionDigits { format.maximumFractionDigits = max }
        if let locale = locale { format.locale = locale }
        
        return format.string(for: self) ?? String(self)
    }
}

public extension BinaryFloatingPoint {
    var abs: Self { Swift.abs(self) }
    
    func integerValue<T: SignedNumeric>() -> T where T: FixedWidthInteger {
        return T(self)
    }
    func toValue<T: BinaryFloatingPoint>() -> T {
        return T(self)
    }
}

public extension BinaryFloatingPoint where Self: LosslessStringConvertible {
    func toString(style: NumberFormatter.Style = .decimal,
                  groupSeparator: String? = nil,
                  decimalSeparator: String? = nil,
                  minFractionDigits: Int? = nil,
                  maxFractionDigits: Int? = nil,
                  locale: Locale? = nil) -> String {
        let format = NumberFormatter()
        format.numberStyle = style
        if let gSeparator = groupSeparator {
            format.groupingSeparator = gSeparator
            format.usesGroupingSeparator = true
        }
        if let dSeparator = decimalSeparator { format.decimalSeparator = dSeparator }
        if let min = minFractionDigits { format.minimumFractionDigits = min }
        if let max = maxFractionDigits { format.maximumFractionDigits = max }
        if let locale = locale { format.locale = locale }
        
        return format.string(for: self) ?? String(self)
    }
}

public extension Int {
    var int64Value: Int64 { return Int64(self) }
}

public extension Int64 {
    var intValue: Int { return Int(self) }
}
