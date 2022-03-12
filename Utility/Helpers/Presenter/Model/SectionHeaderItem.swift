//
//  SectionHeaderItem.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public final class SectionHeaderItem {
    public let view: UIView
    public let height: CGFloat
    
    public init(view: UIView, height: CGFloat) {
        self.view = view
        self.height = height
    }
}
