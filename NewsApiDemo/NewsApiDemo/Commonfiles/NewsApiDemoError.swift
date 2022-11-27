//
//  Error.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

enum NewsApiDemoError: Error {
    
    enum NetworkFailureReason {
        case timeout
        case internetUnavailable
        case networkConnectionLost
        case badRequest
        case emptyResponse
        case general(description: String)
    }
    
    enum CoreDataFailureReason {
        case unableToFetch(String)
        case unableToSave(String)
        case storeUnavailable
        case storeURLUnavailable
    }
    
    case networkFailed(reason: NetworkFailureReason)
    
    case coreDataFailure(reason: CoreDataFailureReason)
    
    case general(reason: String)
    
}

extension NewsApiDemoError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case let .networkFailed(reason):
            return reason.localizedDescription
        case let .coreDataFailure(reason):
            return reason.localizedDescription
        case let .general(reason):
            return reason
        }
    }
    
    var localizedDescription: String {
        return errorDescription ?? ""
    }
}

//MARK: - NetworkFailureReson -
extension NewsApiDemoError.NetworkFailureReason {
    
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "URL request timed out"
        case .internetUnavailable:
            return "Internet is unavaialable"
        case .networkConnectionLost:
            return "The network connection was lost"
        case .badRequest:
        return "Unacceptable status code and wrong request from client"
        case let .general(description):
            return description
        case .emptyResponse:
            return "Received empty response from server"
        }
    }
    
    static var defaultReason: Error {
        return NewsApiDemoError.networkFailed(reason: NewsApiDemoError.NetworkFailureReason.general(description: "Something went wrong"))
    }
}

//MARK: - CoreDataFailureReason -
extension NewsApiDemoError.CoreDataFailureReason {
    
    var localizedDescription: String {
        
        switch self {
        case let .unableToFetch(reason):
            return reason
        case let .unableToSave(reason):
            return reason
        case .storeUnavailable:
            return "Invalid or missing core data store"
        case .storeURLUnavailable:
            return "Invalid or missing core data store url"
        }
    }
}

//MARK: - Error -
extension NewsApiDemoError {
    
    var asMomentError: NewsApiDemoError? {
        self as? NewsApiDemoError
    }
    
    func asMomentError(orFailWith message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> NewsApiDemoError {
        guard let afError = self as? NewsApiDemoError else {
            fatalError(message(), file: file, line: line)
        }
        return afError
    }
    
    func asMomentError(or defaultMomentError: @autoclosure () -> NewsApiDemoError) -> NewsApiDemoError {
        self as? NewsApiDemoError ?? defaultMomentError()
    }
}
