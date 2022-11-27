import Alamofire

typealias HTTPHeader = [String:String]
typealias Parameters = [String:Any]

// MARK:- Class for building URLRequest

// MARK:- Enums

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
}

enum DemoHTTPMethod {
    case get, post, put, delete
    
    var httpMethod: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        }
    }
}

// MARK:- Protocols
protocol NetworkRouterProtocol {
    var method: DemoHTTPMethod { get }
    var bodyParameters: Parameters? { get }
    var url: String { get }
    var headers: HTTPHeader? { get }
    var urlParameters: Parameters? { get }
    var encodingType: ParameterEncoding { get }
    var retryCount: Int? { get }
    var router: NetworkRouter { get }
}

extension NetworkRouterProtocol {
    
    var router: NetworkRouter {
        NetworkRouter(withAPIRouterLogic: self)
    }
    
    var printableHeaderString: NSString {
        return NSString(string: String(any: headers?.stringValue()))
    }
    
    var printablBodyParamsString: NSString {
        return NSString(string:  String(any: bodyParameters?.stringValue()))
        
    }
    
}

// MARK:- Class implementation

final class NetworkRouter: URLRequestConvertible {
    
    let routerLogic: NetworkRouterProtocol
    
    init(withAPIRouterLogic logic: NetworkRouterProtocol) {
        self.routerLogic = logic
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url: URL = try routerLogic.url.asURL()
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = routerLogic.method.httpMethod.rawValue
                
        // additional headers if any - TODO: Add Unit tests
        if let headers: HTTPHeader = routerLogic.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        //TODO: This condition Should move to encoding
        if let arrayData = routerLogic.bodyParameters?["JsonArray"] {
            let jsonAsData = try JSONSerialization.data(withJSONObject: arrayData, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        if routerLogic.encodingType != .none {
            try routerLogic.encodingType.encode(urlRequest: &urlRequest, bodyParameters: routerLogic.bodyParameters, urlParameters: routerLogic.urlParameters)
        }
        return urlRequest
    }
}
