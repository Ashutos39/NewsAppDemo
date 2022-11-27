//
//  NewsApiDemoCoreDataStackConfiguration.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import Foundation


struct NewsApiDemoCoreDataStackConfiguration {
    
    var storeType: NewsApiDemoCoreDataStoreType = .sqlite
    var storeName: String = Bundle.main.appName
}

extension Bundle {
    var appName: String {
        
        let defaultValue = "NewsApiDemo"
        guard let infoDict = Bundle.main.infoDictionary else { return defaultValue }
        if let displayName = infoDict["CFBundleDisplayName"] as? String {
            return displayName
        }
        return infoDict["CFBundleName"] as? String ?? defaultValue
    }
}
