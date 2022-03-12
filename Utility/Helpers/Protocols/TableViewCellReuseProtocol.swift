//
//  TableViewCellReuseProtocol.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public protocol TableViewCellReuseProtocol where Self: UITableViewCell {
    var delegate: AnyObject? { get set}
    
    /// implement this function to update cell
    func setupCell(with data: Any)
}

public extension TableViewCellReuseProtocol {
    var delegate: AnyObject? {
        get {
            nil
        }
        set {
            _ = newValue
        }
    }
}
