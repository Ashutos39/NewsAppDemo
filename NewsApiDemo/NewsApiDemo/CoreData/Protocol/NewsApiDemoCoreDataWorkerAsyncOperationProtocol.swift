//
//  NewsApiDemoCoreDataWorkerAsyncOperationProtocol.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

protocol NewsApiDemoCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute?, predicateType: NSCompoundPredicate.LogicalType, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: NewsApiDemoCDWorkerCompletion<T>)
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: NewsApiDemoCDWorkerCompletion<T>)
    func performAndSave(perform block: @escaping (_ context: NSManagedObjectContext) -> Void, completion: NewsApiDemoCDWorkerErrorCompletion)
    func delete(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject, completion: NewsApiDemoCDWorkerErrorCompletion)
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext: NSManagedObjectContext, completion: NewsApiDemoCDWorkerCompletion<T>)
    func delete(object: NSManagedObject, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerErrorCompletion)
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, completion: NewsApiDemoCDWorkerErrorCompletion)
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerErrorCompletion)
}

extension NewsApiDemoCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute? = nil, predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: NewsApiDemoCDWorkerCompletion<T> = nil) {
        get(type: type, withPredicateAttributes: attributes, predicateType: predicateType, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: NewsApiDemoCDWorkerCompletion<T> = nil) {
        get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil,  fetchLimit: Int? = nil, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerCompletion<T>) {
        get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, inContext: context, completion: completion)
    }
}


