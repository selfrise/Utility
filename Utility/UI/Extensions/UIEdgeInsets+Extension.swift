//
//  UIEdgeInsets+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public extension UIEdgeInsets {
    static func finiteValue(of value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(
            top: value,
            left: value,
            bottom: value,
            right: value)
    }
}
