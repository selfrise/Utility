//
//  UITableView+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation
import UIKit

public extension UITableView {
    func registerCell(withName name:String) {
        self.register(UINib(nibName: name, bundle: .main), forCellReuseIdentifier: name)
    }
    
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for identifier: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier.reuseIdentifier) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
    
    @IBInspectable
    var isEmptyRowsHidden: Bool {
        get {
            return tableFooterView != nil
        }
        set {
            if newValue {
                tableFooterView = UIView(frame: .zero)
            } else {
                tableFooterView = nil
            }
        }
    }
}

public protocol ReusableView {
    
    static var reuseIdentifier: String { get }
    
}

extension ReusableView {
    
    public static var reuseIdentifier: String {
        String(describing: self)
    }
    
}

extension UITableViewCell: ReusableView {}
