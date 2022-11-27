//
//  UIView+Extension.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import UIKit

extension UIView {
    
    func addCornerRadius(withRadius cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
