//
//  NewsApiDemoCoreDataStoreType.swift
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import Foundation

import CoreData

enum NewsApiDemoCoreDataStoreType: String {
    case sqlite, memory
    
    var type: String {
        switch self {
        case .sqlite:
            return NSSQLiteStoreType
        case .memory:
            return NSInMemoryStoreType
        }
    }
}
