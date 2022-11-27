//
//  Dictionary+Extension.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//
import Foundation


extension Dictionary {
    
    
    func stringValue(defaultValue defVal: String = "") -> String {
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return defVal
        }
        let string = String(data: data, encoding: String.Encoding.utf8)
        return string ?? defVal
    }
    
}

//MARK: - GenericDictionary -
extension GenericDictionary {
    //common way to parse error code from api failure response
    func parseAPIFailureErrorCode() -> Int? {
        
        let errorCode = (self["error"] as? Self)?["code"]
        return (errorCode as? Int)
    }
}
