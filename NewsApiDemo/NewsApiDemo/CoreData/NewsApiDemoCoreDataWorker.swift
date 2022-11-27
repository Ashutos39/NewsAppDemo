//
//  NewsApiDemoCoreDataWorker.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

typealias NewsApiDemoCoreDataWorkerOperations = NewsApiDemoCoreDataWorkerSyncOperationProtocol & NewsApiDemoCoreDataWorkerAsyncOperationProtocol & NewsApiDemoCoreDataWorkerUtilityOperationProtocol
typealias NewsApiDemoPredicateAttribute = [String : Any]
typealias NewsApiDemoCDWorkerCompletion<T> = ((Result<[T], Error>) -> Void)?
typealias NewsApiDemoCDWorkerErrorCompletion = ((NewsApiDemoVoidResult<Error>) -> Void)?

final class NewsApiDemoCoreDataWorker {
    
    static let shared = NewsApiDemoCoreDataWorker()
    private(set)var coreDataStack: NewsApiDemoCoreDataStackProtocol
    
    init(withCoreDataStack stack: NewsApiDemoCoreDataStackProtocol = NewsApiDemoCoreDataStack.shared) {
        
        self.coreDataStack = stack
        self.coreDataStack.loadStore { (description, error) in
            if let error = error {
                debugPrint("error loading description store", error.localizedDescription)
            } else {
                debugPrint("store loaded with url", self.coreDataStack.printableStoreURL)
            }
        }
    }
}

extension NewsApiDemoCoreDataWorker {
    
    func entityName<T:NSManagedObject>(forType type: T.Type) -> String {
        return String(describing: type)
    }
    
    func fetchSingle<T: NSManagedObject>(forType type: T.Type, from context: NSManagedObjectContext, with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> T? {
        
        let result = fetchSync(forType: type, from: context, with: predicate, sortDescriptors: sortDescriptors, fetchLimit: 1)
        switch result {
        case .success(let objects):
            return objects?.first
        case .failure(let error):
            debugPrint("error in fetch", error.localizedDescription)
            return nil
        }
    }
    
    func single<T: NSManagedObject>(forType type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute, predicateType: NSCompoundPredicate.LogicalType, from context: NSManagedObjectContext) -> T? {
        
        let predicate = createPredicate(with: attributes, predicateType: predicateType)
        return fetchSingle(forType: type, from: context, with: predicate, sortDescriptors: nil)
    }
    
    func insertNew<T: NSManagedObject>(type:T.Type, in context: NSManagedObjectContext) -> T {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName(forType: type), in: context)!
        let entity = T(entity: entityDescription, insertInto: context)
        return entity
    }
    
    func fetchSync<T: NSManagedObject>(forType type: T.Type, from context: NSManagedObjectContext, with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?) -> Result<[T]?, Error> {
        
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        let fetchRequest = self.createFetchRequest(forType: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
        let result = self.execute(fetchRequest: fetchRequest, inContext: context)
        switch result {
        case .success(let objects):
            return .success(objects)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func all<T: NSManagedObject>(forType type: T.Type, with predicate: NSPredicate? = nil, orderedBy sortDescriptors: [NSSortDescriptor]? = nil, in context: NSManagedObjectContext) -> Result<[T], Error> {
        
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        let request = createFetchRequest(forType: type, predicate: predicate, sortDescriptors: sortDescriptors)
        let result = execute(fetchRequest: request, inContext: context)
        switch result {
        case .success(let objects):
            return .success(objects)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func execute<T: NSManagedObject>(fetchRequest request: NSFetchRequest<T>, inContext context: NSManagedObjectContext) -> Result<[T], Error> {
        
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        var result: Result<[T], Error> = .success([])
        context.performAndWait {
            do {
                let output = try context.fetch(request)
                result = .success(output)
            } catch {
                //Report Error
                result = .failure(error)
                debugPrint("CoreData fetch error \(error)")
            }
        }
        return result
    }
        
    func checkForStoreAvailablity() -> Error? {
        
        guard coreDataStack.hasStore else {
            return NewsApiDemoError.coreDataFailure(reason: NewsApiDemoError.CoreDataFailureReason.storeUnavailable)
        }
        return nil
    }
}
