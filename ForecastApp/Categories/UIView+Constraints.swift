//
//  UIView+Constraints.swift
//  ForecastApp
//
//  Created by Arnaldo Gnesutta on 05/04/2018.
//  Copyright © 2018 Arnaldo Gnesutta. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewsForAutolayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    func addConstraints(_ constraints: [NSLayoutConstraint]...) {
        addConstraints(constraints.flatMap { $0 })
    }
}
extension NSLayoutConstraint {
    static func constraints(_ visualFormat: String, views: [String: Any],
                            options: NSLayoutFormatOptions = [], metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: options, metrics: metrics, views: views)
    }
}

