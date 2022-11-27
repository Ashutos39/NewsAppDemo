//
//  Data+Helper.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

extension Data {
    
    func stringValue(withEncoding encoding: String.Encoding = .utf8, defaultValue defVal: String = "") -> String {
        
        let string = String(data: self, encoding: encoding)
        return string ?? defVal
    }
    func convertToDictionary(withReadingOptions options: JSONSerialization.ReadingOptions = .allowFragments) throws -> GenericDictionary? {
        
        let dictionary = try JSONSerialization.jsonObject(with: self, options: options)
        return dictionary as? GenericDictionary
    }
}
