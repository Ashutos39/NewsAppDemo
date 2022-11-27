//
//  HomeScreenCoreDataWorker.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 27/11/22.
//

import Foundation

struct HomeScreenCoreDataWorker: HelperProtocol {
    
    private let coreDataWorker = NewsApiDemoCoreDataWorker()

    func saveArticleDataToCoreData(articleResponse: [Article],  completionHandler: @escaping (Bool) -> Void) {
        coreDataWorker.performAndSave { (context: NewsApiDemoManagedObjectContext) in
            for article in articleResponse {
                let articleData = coreDataWorker.getOrCreateSingle(type: NewsArticle.self,withPredicateAttributes: [NewsArticle.primaryKey: article.url], from: context)
                articleData.mapArticleDataToCoreData(article: article)
            }
        } completion: { (result: NewsApiDemoVoidResult<Error>) in
            switch result {
            case .success:
                completionHandler(true)
                debugPrint("Article responce saved sucessfully")
            case .failure(let failure):
                completionHandler(false)
                debugPrint(failure.localizedDescription)
            }
        }
    }
    
    func getArticleDataFromDB( completionHandler: @escaping ([NewsArticle]?) -> Void) {
        coreDataWorker.get(type: NewsArticle.self) { (result: Result<[NewsArticle], Error>) in
            switch result {
            case .success(let newsArticle):
                completionHandler(newsArticle)
            case .failure(let error):
                completionHandler(nil)
            }
        }
    }
    
    func updateIsFav(article: NewsArticle, isFavourite: Bool,completionHandler: @escaping (Bool) -> Void) {
        coreDataWorker.performAndSave { (context: NewsApiDemoManagedObjectContext) in
            let articleData = coreDataWorker.getOrCreateSingle(type: NewsArticle.self, withPredicateAttributes: [NewsArticle.primaryKey: article.url], from: context)
            articleData.updateFavourite(isFav: isFavourite)
                        
        } completion: { (result: NewsApiDemoVoidResult<Error>) in
            switch result {
            case .success:
                completionHandler(true)
                debugPrint("Article favourite saved sucessfully")
            case .failure(let failure):
                completionHandler(false)
                debugPrint(failure.localizedDescription)
            }
        }
    }
}
