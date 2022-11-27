//
//  HomeViewModel.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

protocol HomeViewModelDelegate {
    func updateUI()
    func showError(errorMessage: String)
}

final class HomeViewModel {
    
    private let networkManager: NetworkManager = NetworkManager()
    private lazy var homeApiWorker = HomeApiWorker(withNetworkManager: networkManager)
    private lazy var homeCoreDataWorker = HomeScreenCoreDataWorker()
    
    var delegate: HomeViewModelDelegate?
    var articles: [NewsArticle] = []
    
    private var deaultKeyWord = "keyword"
    
    func getHomeData(searchKey: String) {
        if DemoNetworkReachabilityManager.isConnectedToNetwork {        getDataFromApi(searchKey: searchKey)
        } else {
            getDataFromDB()
        }
    }
    
    func updateIsFavourite(isFavorite: Bool, article: NewsArticle?) {
        guard let article = article else {
           delegate?.showError(errorMessage: "article data not found")
            return
        }
        homeCoreDataWorker.updateIsFav(article: article, isFavourite: isFavorite) { [weak self] isSucess in
            if !isSucess {
                self?.delegate?.showError(errorMessage: "favourite saved unsucessful")
            }
            self?.getDataFromDB()
        }
    }
}

private extension HomeViewModel {
    func getDataFromApi(searchKey: String) {
        var currentSearchKeyword = searchKey
        if currentSearchKeyword.isEmpty {
            currentSearchKeyword = deaultKeyWord
        }
        homeApiWorker.getHomeData(searchWord: currentSearchKeyword) { [weak self] (result: Result<NewsModel, NewsApiDemoError>) in
            switch result {
            case .success(let response):
                if let articles = response.articles, !articles.isEmpty {
                    self?.homeCoreDataWorker.deleteAll() { [weak self] isSucess in
                        if isSucess {
                            self?.saveDataFromCoreData(articles: articles)
                        } else {
                            self?.delegate?.showError(errorMessage: "Article response is empty")
                        }
                    }
                } else {
                    self?.delegate?.showError(errorMessage: "Article response is empty")
                }
            case .failure(let error):
                self?.delegate?.showError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func saveDataFromCoreData(articles: [Article]) {
        homeCoreDataWorker.saveArticleDataToCoreData(articleResponse: articles) { [weak self] isSucess in
            if isSucess {
                self?.getDataFromDB()
            } else {
                self?.delegate?.showError(errorMessage: "No articles found")
            }
        }
    }
    
    func getDataFromDB() {
        homeCoreDataWorker.getArticleDataFromDB { [weak self] newsArticles in
            if let article = newsArticles, !article.isEmpty {
                self?.articles.removeAll()
                self?.articles = article.reversed()
                self?.delegate?.updateUI()
            } else {
                self?.delegate?.showError(errorMessage: "No articles found")
            }
        }
    }
}
