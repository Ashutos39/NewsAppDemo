//
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//


import Foundation


// MARK:- Struct for encoding JSON request body

struct JSONParameterEncoder: ParameterEncodable {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) == nil {
                urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            }
        }catch {
            throw EncodeError.encodingFailed
        }
    }
}
 
