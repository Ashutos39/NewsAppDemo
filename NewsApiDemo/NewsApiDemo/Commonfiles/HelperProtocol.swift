//
//  HelperProtocol.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation

typealias GenericDictionary = [String:Any]

protocol HelperProtocol {}


extension HelperProtocol {
    func mainThread(_  work: @escaping () -> Void) {
        if Thread.current.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
