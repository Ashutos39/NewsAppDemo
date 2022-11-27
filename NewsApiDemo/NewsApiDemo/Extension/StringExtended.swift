//
//  StringExtended.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation


extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    init(any anyValue:Any?, defaultValue: String = "") {
        
        self = defaultValue
        if let str = anyValue as? String {
            self = String(format: "%@", str).trimmed
        } else if let num = anyValue as? NSNumber {
            self = String(format: "%@", num).trimmed
        }
    }
    
    func formatedDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: self) ?? Date()
            dateFormatter.dateFormat = "dd MMM YYYY"
            return dateFormatter.string(from: date)
        }
}
