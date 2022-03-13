//
//  CollectionViewPresenter.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 12.03.2022.
//

import UIKit

public protocol CollectionViewPresenterDelegate: AnyObject {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}

public final class CollectionViewPresenter: NSObject {
    public var isTemplate: Bool = false
    public var sections: [CollectionViewSectionData] = []
    public var action: ((IndexPath, CollectionViewItem) -> Void)?
    public weak var delegate: CollectionViewPresenterDelegate?
    
    public init(with sections: [CollectionViewSectionData]) {
        self.sections = sections
    }
}

extension CollectionViewPresenter: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = sections[indexPath.section].rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.identifier, for: indexPath)
        guard let reuseCell = cell as? CollectionViewCellReuseProtocol,
              let cellData = data.data else {
                  return UICollectionViewCell()
              }
        cell.isSelected = data.isSelected
        if data.isSelected {
            collectionView.selectItem(
                at: indexPath,
                animated: false,
                scrollPosition: .centeredHorizontally
            )
        }
        reuseCell.delegate = data.delegate
        reuseCell.setupCell(with: cellData)
        return cell
    }
}

extension CollectionViewPresenter: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        action?(indexPath, sections[indexPath.section].rows[indexPath.row])
    }
}

extension CollectionViewPresenter: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        sections[indexPath.section].rows[indexPath.row].size
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        sections[section].inset
    }
}

extension CollectionViewPresenter {
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        delegate?.scrollViewWillEndDragging(
            scrollView,
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating(scrollView)
    }
}

extension CollectionViewPresenterDelegate {
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) { }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
}
