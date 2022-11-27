//
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation
import Alamofire

struct DemoNetworkReachabilityManager {
    
    static var isConnectedToNetwork: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    let networkConnection = NetworkReachabilityManager()

    func startListeningNetworkState(handler: @escaping(Bool) -> Void){
        networkConnection?.startListening { status in
            switch status{
            case .reachable(.cellular):
                debugPrint("Network reachable through cellular")
                handler(true)
            case .reachable(.ethernetOrWiFi):
                debugPrint("Network reachable through wifi")
                handler(true)
            case .notReachable:
                debugPrint("Network not reachable")
                handler(false)
            default:
                debugPrint("unknown status")
                handler(false)
            }
        }
    }
    
    func stopListingNetworkState() {
        networkConnection?.stopListening()
        debugPrint("Stopped listening to network")
    }
}
