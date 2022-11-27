//
//  NewsApiDemoCoreDataWorker+SyncOperation.swift
//  NewsApiDemoDemoApp
//
//  Created by Ashutos Sahoo on 11/10/22.
//

import CoreData

extension NewsApiDemoCoreDataWorker: NewsApiDemoCoreDataWorkerSyncOperationProtocol {
    
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int?) -> Result<[T]?, Error> {
        
        var result: Result<[T]?, Error> = Result.success(nil)
        coreDataStack.performSyncTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                result = self.performFetch(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, inContext: context)
            case .failure(let error):
                result = .failure(error)
            }
        }
        return result
    }
    
    func getSync<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext context: NSManagedObjectContext) -> Result<[T]?, Error> {
        
        let result = performFetch(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, inContext: context)
        return result
    }
    
    func deleteSync(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject) -> Result<Any?, Error> {
        
        var result: Result<Any?, Error> = Result.success(nil)
        coreDataStack.performSyncTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                result = self.performDelete(object: work(context), inContext: context)
            case .failure(let error):
                result = .failure(error)
            }
        }
        return result
    }
    
    func deleteSync(object: NSManagedObject, inContext context: NSManagedObjectContext) -> Result<Any?, Error> {
        
        let result = self.performDelete(object: object, inContext: context)
        return result
    }
    
    func performAndSaveSync(perform block: @escaping (_ context: NSManagedObjectContext) -> Void) -> Result<Any?, Error> {

        var result: Result<Any?, Error> = Result.success(nil)
        coreDataStack.performSyncTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                block(context)
                result = save(inContext: context)
            case .failure(let error):
                result = .failure(error)
            }
        }
        return result
    }
    
    func deleteAllSync<T: NSManagedObject>(forType type: T.Type) -> Result<Any?, Error> {
        
        var result: Result<Any?, Error> = Result.success(nil)
        coreDataStack.performSyncTask { (taskResult: NewsApiDemoPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                result = self.performDeleteAll(forType: type, inContext: context)
            case .failure(let error):
                result = .failure(error)
            }
        }
        return result
    }
    
    func deleteAllSync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext) -> Result<Any?, Error> {
        
        var result: Result<Any?, Error> = Result.success(nil)
        context.performAndWait {
            result = self.performDeleteAll(forType: type, inContext: context)
        }
        return result
    }
}

//MARK: - Private -
private extension NewsApiDemoCoreDataWorker {
    
    func performFetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int?, inContext context: NSManagedObjectContext) -> Result<[T]?, Error> {
        
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        let fetchRequest = createFetchRequest(forType: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: nil)
        do {
            let result = try context.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func performDelete(object: NSManagedObject, inContext context: NSManagedObjectContext) -> Result<Any?, Error> {
        
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        context.delete(object)
        return save(inContext: context)
    }
    
    func performDeleteAll<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext) -> Result<Any?, Error> {
        
        let allResult = self.all(forType: type, in: context)
        switch allResult {
        case .success(let objects):
            objects.forEach { context.delete($0) }
            return save(inContext: context)
        case .failure(let error):
           return .failure(error)
        }
    }
}
