//
//  ArrangedSubviewItem.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public final class ArrangedSubviewItem {
    public let view: UIView
    public let height: CGFloat
    public let leftMargin: CGFloat
    public let rightMargin: CGFloat
    
    public init(
        view: UIView,
        height: CGFloat,
        leftMargin: CGFloat = 0.0,
        rightMargin: CGFloat = 0.0
    ) {
        self.view = view
        self.height = height
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
    }
}
