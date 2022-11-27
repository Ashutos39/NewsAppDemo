//
//  UITableViewCell+Extension.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import Foundation
import UIKit

protocol ReusableCellProtocol {
    static var reuseIdentifier: String { get }
}

extension ReusableCellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCellProtocol {}

extension UITableView {
    func registerCell<T: UITableViewCell>(_:T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeResuableCell<T:UITableViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T ?? T()
    }
}
