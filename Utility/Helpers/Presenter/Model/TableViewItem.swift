//
//  TableViewItem.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public final class TableViewItem {
    public let identifier: String
    public let height: CGFloat
    public let data: Any?
    public let editingStyle: UITableViewCell.EditingStyle
    public let canMove: Bool
    public var isSelected: Bool = false
    public weak var delegate: AnyObject?
    
    public init(
        identifier: String,
        height: CGFloat,
        data: Any?,
        editingStyle: UITableViewCell.EditingStyle = .none,
        canMove: Bool = false,
        isSelected: Bool = false,
        delegate: AnyObject? = nil
    ) {
        self.identifier = identifier
        self.height = height
        self.data = data
        self.editingStyle = editingStyle
        self.canMove = canMove
        self.isSelected = isSelected
        self.delegate = delegate
    }
}

public extension TableViewItem {
    
    /// A constant representing the default value for a given dimension to calculate dynamic cell height.
    static let automaticDimension = UITableView.automaticDimension
}

public final class TableViewSectionData {
    public var header: SectionHeaderItem?
    public var rows: [TableViewItem]
    
    public init(header: SectionHeaderItem? = nil, rows: [TableViewItem]) {
        self.header = header
        self.rows = rows
    }
}
