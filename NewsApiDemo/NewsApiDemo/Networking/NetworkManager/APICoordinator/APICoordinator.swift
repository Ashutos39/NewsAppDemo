//
//  APICoordinator.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

final class APICoordinator: APICoordinatorProtocol {

    private let networkManager: NetworkManagerProtocol
    init(withNetworkManager network: NetworkManagerProtocol) {

        networkManager = network
    }
    
    func requestToCallAPIWithDecodableResponse<T>(with router: GenericNetworkRouter, cancelLast:Bool = false, _ completion: @escaping (_ result: Result<T, NewsApiDemoError>) -> Void) where T: Decodable {
        
        if cancelLast {
            networkManager.cancelRequest(withName: router.url)
        }
        networkManager.performRequestWithDecodableResponse(route: router) { [weak self] (result: Result<T, NewsApiDemoError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestToCallAPI(with router: GenericNetworkRouter, cancelLast:Bool = false, _ completion: @escaping CompletionResponse) {
        
        if cancelLast {
            networkManager.cancelRequest(withName: router.url)
        }
        networkManager.performRequestWithResponse(route: router) { [weak self] (data: Data?, error: NewsApiDemoError?) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(data,nil)
            }
        }
    }
}
