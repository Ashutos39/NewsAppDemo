//
//  NewsArticle+Extension.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 27/11/22.
//

import Foundation

extension NewsArticle {
    
    static var primaryKey: String {
      return "url"
    }
    
    func mapArticleDataToCoreData(article: Article) {
        self.title = article.title
        self.articleDescription = article.articleDescription
        self.url = article.url
        self.imageUrl = article.urlToImage
        self.publishedAt = article.publishedAt
        self.author = article.author
        self.isFavourite = false
    }
    
    func updateFavourite(isFav: Bool) {
        self.isFavourite = isFav
    }
}
