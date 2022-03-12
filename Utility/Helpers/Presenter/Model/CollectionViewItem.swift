//
//  CollectionViewItem.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public final class CollectionViewItem {
    public var identifier: String
    public var size: CGSize
    public var isSelected: Bool
    public var data: Any?
    public weak var delegate: AnyObject?
    
    public init(
        identifier: String,
        size: CGSize,
        isSelected: Bool = false,
        data: Any? = nil,
        delegate: AnyObject? = nil
    ) {
        self.identifier = identifier
        self.size = size
        self.isSelected = isSelected
        self.data = data
        self.delegate = delegate
    }
}

public final class CollectionViewSectionData {
    public let header: SectionHeaderItem?
    public var rows: [CollectionViewItem]
    public let inset: UIEdgeInsets
    
    public init(
        header: SectionHeaderItem? = nil,
        rows: [CollectionViewItem],
        inset: UIEdgeInsets = .zero
    ) {
        self.header = header
        self.rows = rows
        self.inset = inset
    }
}
