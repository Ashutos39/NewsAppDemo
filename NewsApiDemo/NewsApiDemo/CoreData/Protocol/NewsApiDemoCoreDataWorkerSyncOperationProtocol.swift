//
//  NewsApiDemoCoreDataWorkerSyncOperationProtocol.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData


protocol NewsApiDemoCoreDataWorkerSyncOperationProtocol {
    
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?) -> Result<[T]?, Error>
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext: NSManagedObjectContext) -> Result<[T]?, Error>
    func deleteSync(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject) -> Result<Any?, Error>
    func deleteSync(object: NSManagedObject, inContext context: NSManagedObjectContext) -> Result<Any?, Error>
    func performAndSaveSync(perform block: @escaping (_ context: NSManagedObjectContext) -> Void) -> Result<Any?, Error>
    func deleteAllSync<T: NSManagedObject>(forType type: T.Type) -> Result<Any?, Error>
    func deleteAllSync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext) -> Result<Any?, Error>
}

extension NewsApiDemoCoreDataWorkerSyncOperationProtocol {
    
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) -> Result<[T]?, Error> {
        return getSync(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }
    
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, inContext: NSManagedObjectContext) -> Result<[T]?, Error> {
        return getSync(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, inContext: inContext)
    }
}

