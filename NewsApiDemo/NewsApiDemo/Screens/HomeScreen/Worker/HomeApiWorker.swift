//
//  HomeApiWorker.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation


struct HomeApiWorker: APIWorkerProtocol {
    private let apiCoordinator: APICoordinatorProtocol
    
    init(withNetworkManager manager: NetworkManagerProtocol) {
        apiCoordinator = APICoordinator(withNetworkManager: manager)
    }
    
    var url: String {
        return APPConstant.baseUrl
    }
    
    func getHomeData(searchWord: String,_ completionHandler: @escaping (_ result: Result<NewsModel, NewsApiDemoError>) -> Void) {
        let finalUrl = url + "\(searchWord)&apiKey=\(APPConstant.apiKey)"
        let router = GenericNetworkRouter(encodingType: .jsonEncoding, method: .get, bodyParameters: nil, url: finalUrl, headers: nil, urlParameters: nil, retryCount: 0)
        apiCoordinator.requestToCallAPIWithDecodableResponse(with: router, completionHandler)
    }
    
}
