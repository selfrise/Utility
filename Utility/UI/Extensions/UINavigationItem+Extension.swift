//
//  UINavigationItem+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import class UIKit.UINavigationItem
import class UIKit.UIBarButtonItem

public extension UINavigationItem {
    
    func removeBackBarButtonTitle() {
        backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .done,
            target: nil,
            action: nil
        )
    }
}
