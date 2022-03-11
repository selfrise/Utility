//
//  UINavigationController+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import UIKit

public extension UINavigationController {
    
    func setStandartAppearance() {
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        view.tintAdjustmentMode = .normal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes[.foregroundColor] = UIColor.black
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
