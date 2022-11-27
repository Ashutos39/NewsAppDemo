//
//  NewsApiDemoVoidResult.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 27/11/22.
//

import Foundation


enum NewsApiDemoVoidResult<Failure> where Failure: Error {
    case success
    case failure(Failure)
}

