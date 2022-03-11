//
//  UICollectionView+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import Foundation
import UIKit

public extension UICollectionView {
    
    func dequeueAutomatic<T:UICollectionViewCell>(collectionCell : T.Type, indexPath : IndexPath) -> T{
        dequeueReusableCell(withReuseIdentifier: collectionCell.className, for: indexPath) as! T
    }
    
    func registerCell<T: UICollectionViewCell>(with cell:T.Type) {
        register(UINib(nibName: String(describing: cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: cell.self))
    }
}
