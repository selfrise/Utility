//
//  NSObject+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        String(describing: self).components(separatedBy: ".").last!
    }
}
