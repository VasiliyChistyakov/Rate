//
//  Extensions.swift
//  Valuta
//
//  Created by Василий  on 10.09.2022.
//

import UIKit

// MARK: - UIView
extension UIView {
    func addSubviews(_ views: [Any]) {
        views.forEach { if let view = $0 as? UIView {
                self.addSubview(view)
            }
        }
    }
}
