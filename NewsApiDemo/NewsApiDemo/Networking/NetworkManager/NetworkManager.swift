import Alamofire

// MARK:- Typealias
typealias CompletionDecodableResponse<T:Decodable> = ((Result<T, NewsApiDemoError>) -> Void)
typealias CompletionResponse = ((Data?, NewsApiDemoError?) -> Void)
typealias NetworkRequestName = String
typealias DownloadRequestionOption = DownloadRequest.Options
typealias RequestName = String
typealias DownloadCompletionResponse = (String) -> Void
typealias AlamofireDecodableDataResponse = DataResponse
typealias AlamofireError = AFError
typealias AlamofireDataResponse = AFDataResponse<Any>

// MARK:- NetworkManager
final class NetworkManager {
    
    private let session: Alamofire.Session
    private let jsonDecoder = JSONDecoder()
    private let responseParsingManager: NetworkResponseParser
    
    private var requestDictionary: [NetworkRequestName: DataRequest] = [:] //saving all the data request to provide cancellation feature of ongoing request
    private let requestInterceptor: NetworkManagerInterceptor = NetworkManagerInterceptor()
    
    init(withSession sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default, responseParser parser: NetworkResponseParser = NetworkResponseParser()) {
        
        session = Alamofire.Session(configuration: sessionConfiguration)
        responseParsingManager = parser
    }
}

// MARK:- NetworkManagerProtocol -
extension NetworkManager : NetworkManagerProtocol {
    
    // MARK:- NetworkManager method with repsonse Decoded
    func performRequestWithDecodableResponse<T:Decodable>(route: NetworkRouterProtocol, decoder: JSONDecoder? = nil, completion: @escaping CompletionDecodableResponse<T>) {
        
        debugPrint("calling API for url", route.url, "http method",route.method, "headers", NSString(string: route.headers?.stringValue() ?? ""), "body params", NSString(string: route.bodyParameters?.stringValue() ?? ""))
        
        requestInterceptor.setRetryLimit(with: route.retryCount ?? 0)
        let router: NetworkRouter = route.router
        let apiDecoder = decoder ?? jsonDecoder
        let dataRequest = session.request(router)
            .validate()
            .responseDecodable(decoder: apiDecoder) { [weak self] (response: DataResponse<T, AFError>) in
                
                guard let strongSelf = self else { return }
                //Delete the saved request once it is completed
                strongSelf.responseParsingManager.parseDecodableResponse(response, completion)
            }
    }
    
    // MARK:- NetworkManager method with repsonse Data
    func performRequestWithResponse(route: NetworkRouterProtocol, completion: @escaping CompletionResponse) {
       
        debugPrint("calling API for url", route.url, "http method", route.method, "headers", route.printableHeaderString, "body params", route.printablBodyParamsString)
        
        session.request(route.router).validate().responseJSON { [weak self] (response: AlamofireDataResponse) in
            self?.responseParsingManager.parseResponse(response, completion)
        }
    }
    
    func downloadResource(from url: URL, destinationUrl: URL?, options: DownloadRequestionOption, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        
        var destination: DownloadRequest.Destination? = nil
        if let destinationUrl = destinationUrl {
            destination = { _, _ in
                return (destinationUrl, options)
            }
        }
        AF.download(url, to: destination).response { response in
            switch response.result {
            case .success(let url):
                completion(url, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

