//
//  NewsApiDemoCoreDataStackProtocol.swift
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

typealias NewsApiDemoPersistentStoreLoadCompletion = (((NSPersistentStoreDescription?, Error?) -> Void)?)
typealias NewsApiDemoManagedObjectContext = NSManagedObjectContext
typealias NewsApiDemoManagedObject = NSManagedObject
typealias NewsApiDemoPerformTaskResult = (Result<NSManagedObjectContext, NewsApiDemoError>)
typealias NewsApiDemoPerformTaskCompletion = (NewsApiDemoPerformTaskResult) -> Void

protocol NewsApiDemoCoreDataStackProtocol {
    
    init?(withConfiguration config: NewsApiDemoCoreDataStackConfiguration)
    var config: NewsApiDemoCoreDataStackConfiguration { get }
    var hasStore: Bool { get }
    var persistentContainer: NSPersistentContainer {get}
    var viewContext: NSManagedObjectContext {get}
    var backgroundContext: NSManagedObjectContext {get}
    var storeURL: URL? {get}
    func loadStore(_ completion: NewsApiDemoPersistentStoreLoadCompletion)
    func deleteStore() -> NewsApiDemoVoidResult<Error>
    func performBackgroundTask(_ block: @escaping NewsApiDemoPerformTaskCompletion)
    func performBackgroundTaskOnNewContext(_ block: @escaping NewsApiDemoPerformTaskCompletion)
    func performForegroundTask(_ block: @escaping NewsApiDemoPerformTaskCompletion)
    func performSyncTask(_ block: NewsApiDemoPerformTaskCompletion)
}

extension NewsApiDemoCoreDataStackProtocol {
  var printableStoreURL: String {
    return self.persistentContainer.persistentStoreDescriptions.first?.url?.absoluteString.removingPercentEncoding ?? ""
  }
}
