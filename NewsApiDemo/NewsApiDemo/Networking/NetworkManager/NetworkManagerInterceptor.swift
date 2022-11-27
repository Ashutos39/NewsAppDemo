//
//  NetworkManagerInterceptor.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation
import Alamofire

final class NetworkManagerInterceptor: RequestInterceptor {
    
    private(set) var retryLimit = 0
    
    ///RequestRetrier protocol type determines if a request has to be retried
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else { return }
        
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        default:
            if request.retryCount < retryLimit {
                debugPrint("NetworkManagerInterceptor: Retrying..... Request \(request.description) since retry limit is \(retryLimit) and current retry count is \(request.retryCount)")
                completion(.retry)
                return
            }
            completion(.doNotRetry)
        }
    }
    
    ///RequestAdapter protocol type that can optionally change the URLRequest
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest)) // Current requirement no need to modify anything in the request
    }
    
    func setRetryLimit(with count:Int) {
        retryLimit = count
    }
}
