//
//  NewsArticle+CoreDataProperties.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 27/11/22.
//
//

import Foundation
import CoreData


extension NewsArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var isFavourite: Bool

}

extension NewsArticle : Identifiable {

}
