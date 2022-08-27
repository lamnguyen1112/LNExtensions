//
//  String+Encode.swift
//  
//
//  Created by Lazyman on 8/27/22.
//

import Foundation

public extension String {
    var encodeUrlPercentEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    func encodeUrl(_ characterSet: CharacterSet = .urlFragmentAllowed) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
    }
}
