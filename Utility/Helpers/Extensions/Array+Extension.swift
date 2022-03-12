//
//  Array+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import Foundation

extension Array {
    
    public struct IndexOutOfBoundsError: Error {}
    
    public func element(at index: Int) throws -> Element {
        guard index >= 0 && index < self.count else {
            throw IndexOutOfBoundsError()
        }
        return self[index]
    }
    
    public mutating func move(from oldIndex: Index, to newIndex: Index) {
        guard oldIndex != newIndex else {
            return
        }
        
        if abs(newIndex - oldIndex) == 1 {
            return self.swapAt(oldIndex, newIndex)
        }
        
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
