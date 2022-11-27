//
//  NewsApiDemoCoreDataWorkerUtilityOperation.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

protocol NewsApiDemoCoreDataWorkerUtilityOperationProtocol {
    
    var backgroundContext: NSManagedObjectContext? { get }
    var mainContext: NSManagedObjectContext? { get }
    var persistentContainer: NSPersistentContainer? { get }
    @discardableResult
    func getOrCreateSingle<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute?, predicateType predicate: NSCompoundPredicate.LogicalType, from context: NSManagedObjectContext) -> T
    func createPredicate(with attributes: NewsApiDemoPredicateAttribute, predicateType: NSCompoundPredicate.LogicalType) -> NSPredicate
    func save(inContext context: NSManagedObjectContext) -> Result<Any?, Error>
    func clearDatabase() -> NewsApiDemoVoidResult<Error>
}

extension NewsApiDemoCoreDataWorkerUtilityOperationProtocol {
    @discardableResult
    func getOrCreateSingle<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute? = nil, predicateType predicate: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, from context: NSManagedObjectContext) -> T {
        return getOrCreateSingle(type: type, withPredicateAttributes: attributes, predicateType: predicate, from: context)
    }
    
    func createPredicate(with attributes: NewsApiDemoPredicateAttribute,
                         predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and) -> NSPredicate {
        return createPredicate(with: attributes, predicateType: predicateType)
    }
}


