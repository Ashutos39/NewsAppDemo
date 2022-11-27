//
//
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//


// MARK:- Struct for encoding URL with query parameters


import Foundation

struct URLParameterEncoder: ParameterEncodable {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url: URL = urlRequest.url else { throw EncodeError.missingURL }
        
        if var urlComponents: URLComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem: URLQueryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) == nil {
            urlRequest.setValue(ContentType.urlEncoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
    }
}
