//
//  NetworkManagerProtocol.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func performRequestWithDecodableResponse<T:Decodable>(route: NetworkRouterProtocol, decoder: JSONDecoder?, completion: @escaping CompletionDecodableResponse<T>)
    func performRequestWithResponse(route: NetworkRouterProtocol, completion: @escaping CompletionResponse)
    func cancelRequest(withName name: String)
    func downloadResource(from url: URL, destinationUrl: URL?, options: DownloadRequestionOption, completion: @escaping (_ url: URL?, _ error: Error?) -> Void)
}

//MARK: - Default Parameters
extension NetworkManagerProtocol {
    
    func performRequestWithDecodableResponse<T:Decodable>(route: NetworkRouterProtocol, decoder: JSONDecoder? = nil, completion: @escaping CompletionDecodableResponse<T>) {
        performRequestWithDecodableResponse(route: route, decoder: decoder, completion: completion)
    }
    
    func downloadResource(from url: URL, destinationUrl: URL? = nil, options: DownloadRequestionOption = [.removePreviousFile, .createIntermediateDirectories], completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        downloadResource(from: url, destinationUrl: destinationUrl, options: options, completion: completion)
    }
    
    func cancelRequest(withName name: String) { }
}


