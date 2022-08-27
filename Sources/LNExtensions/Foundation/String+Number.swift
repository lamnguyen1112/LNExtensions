//
//  String+Number.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension String {
    var int: Int? { return Int(self.deleteSub(",")) }
    var int64: Int64? { return Int64(self.deleteSub(",")) }
    var intValue: Int { return Int(self.deleteSub(",")) ?? 0 }
    var int64Value: Int64 { return Int64(self.deleteSub(",")) ?? 0 }    
}
