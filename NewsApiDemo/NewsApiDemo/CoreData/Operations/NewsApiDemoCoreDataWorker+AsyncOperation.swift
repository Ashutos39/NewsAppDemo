//
//  NewsApiDemoCoreDataWorker+AsyncOperation.swift
//
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

extension NewsApiDemoCoreDataWorker: NewsApiDemoCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: NewsApiDemoPredicateAttribute? = nil, predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: NewsApiDemoCDWorkerCompletion<T> = nil) {
        
        var predicate: NSPredicate? = nil
        if let attributes = attributes {
            predicate = createPredicate(with: attributes, predicateType: predicateType)
        }
        coreDataStack.performBackgroundTask { (result: NewsApiDemoPerformTaskResult) in
            
            switch result {
            case .success(let context):
                return self.get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit,  inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil,  completion: NewsApiDemoCDWorkerCompletion<T> = nil) {
        
        coreDataStack.performBackgroundTask { (result: NewsApiDemoPerformTaskResult) in
            
            switch result {
            case .success(let context):
                return self.get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit,  inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerCompletion<T>) {
        
        if let error = checkForStoreAvailablity() {
            completion?(.failure(error))
            return
        }
        context.perform {
            
            let fetchRequest = self.createFetchRequest(forType: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
            do {
                let result = try context.fetch(fetchRequest)
                completion?(.success(result))
            } catch {
                completion?(.failure(error))
            }
        }
    }
        
    func performAndSave(perform block: @escaping (_ context: NSManagedObjectContext) -> Void, completion: NewsApiDemoCDWorkerErrorCompletion){
        
        coreDataStack.performBackgroundTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                block(context)
                let result = self.save(inContext: context)
                switch result {
                case .success(_):
                    completion?(NewsApiDemoVoidResult.success)
                case .failure(let error):
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func delete(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject, completion: NewsApiDemoCDWorkerErrorCompletion = nil) {
        
        coreDataStack.performBackgroundTaskOnNewContext { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
            self.delete(object: work(context), inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func delete(object: NSManagedObject, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerErrorCompletion = nil) {
        
        coreDataStack.performBackgroundTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(_):
                context.delete(object)
                let result = self.save(inContext: context)
                switch result {
                case .success(_):
                    completion?(NewsApiDemoVoidResult.success)
                case .failure(let error):
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, completion: NewsApiDemoCDWorkerErrorCompletion) {
        
        coreDataStack.performBackgroundTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                self.perfromDeleteAll(forType: type, inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerErrorCompletion) {
        
        if let error = checkForStoreAvailablity() {
            completion?(.failure(error))
            return
        }
        context.perform {
            self.perfromDeleteAll(forType: type, inContext: context, completion: completion)
        }
    }
}

private extension NewsApiDemoCoreDataWorker {
    
    func perfromDeleteAll<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: NewsApiDemoCDWorkerErrorCompletion) {
        
        let result = self.all(forType: type, in: context)
        switch result {
        case .success(let objects):
            objects.forEach {
                context.delete($0)
            }
            let result = self.save(inContext: context)
            switch result {
            case .success(_):
                completion?(NewsApiDemoVoidResult.success)
            case .failure(let error):
                completion?(NewsApiDemoVoidResult.failure(error))
                debugPrint("error in deleteAll", error.localizedDescription)
            }
            
        case .failure(let error):
            completion?(NewsApiDemoVoidResult.failure(error))
            debugPrint("error in deleteAll", error.localizedDescription)
        }
    }
}
