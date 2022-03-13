//
//  LoadMoreControl.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 13.03.2022.
//

import UIKit

public protocol LoadMoreControlDelegate: AnyObject {
    func loadMoreControl(didStartAnimating loadMoreControl: LoadMoreControl)
    func loadMoreControl(didStopAnimating loadMoreControl: LoadMoreControl)
}

public final class LoadMoreControl {
    private let spacingFromLastCell: CGFloat
    private let indicatorHeight: CGFloat
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var scrollView: UIScrollView?
    public weak var delegate: LoadMoreControlDelegate?
    
    private var defaultY: CGFloat {
        guard let height = scrollView?.contentSize.height else {
            return 0.0
            
        }
        return height + spacingFromLastCell
    }
    
    public init(
        scrollView: UIScrollView,
        spacingFromLastCell: CGFloat,
        indicatorHeight: CGFloat,
        color: UIColor = .red
    ) {
        self.scrollView = scrollView
        self.spacingFromLastCell = spacingFromLastCell
        self.indicatorHeight = indicatorHeight
        
        let size:CGFloat = 40
        let frame = CGRect(
            x: (scrollView.frame.width-size)/2,
            y: scrollView.contentSize.height + spacingFromLastCell,
            width: size,
            height: size
        )
        
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.color = color
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        scrollView.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = isHidden
        self.activityIndicatorView = activityIndicatorView
    }
    
    private var isHidden: Bool {
        guard let scrollView = scrollView else {
            return true
        }
        return scrollView.contentSize.height < scrollView.frame.size.height
    }
    
    public func didScroll() {
        guard let scrollView = scrollView,
              let activityIndicatorView = activityIndicatorView else {
                  return
              }
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        
        guard !activityIndicatorView.isHidden && offsetY >= 0 else {
            return
        }
        
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = offsetY - contentDelta
        
        let newY = defaultY-offsetDelta
        if newY < scrollView.frame.height {
            activityIndicatorView.frame.origin.y = newY
        } else {
            if activityIndicatorView.frame.origin.y != defaultY {
                activityIndicatorView.frame.origin.y = defaultY
            }
        }
        
        if !activityIndicatorView.isAnimating &&
            offsetY > contentDelta &&
            offsetDelta >= indicatorHeight &&
            !activityIndicatorView.isAnimating {
            activityIndicatorView.startAnimating()
            delegate?.loadMoreControl(didStartAnimating: self)
        }
        
        if scrollView.isDecelerating &&
            activityIndicatorView.isAnimating &&
            scrollView.contentInset.bottom == 0{
            UIView.animate(withDuration: 0.3) { [weak self, weak scrollView] in
                guard let bottom = self?.indicatorHeight else {
                    return
                }
                scrollView?.contentInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: bottom,
                    right: 0
                )
            }
        }
    }
    
    public func stop() {
        guard let scrollView = scrollView else {
            return
        }
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            UIView.animate(withDuration: 0.3, animations: { [weak scrollView] in
                scrollView?.contentInset = .zero
            }) { [weak self] result in
                guard result else {
                    return
                }
                self?.endAnimating()
            }
        } else {
            scrollView.contentInset = .zero
            endAnimating()
        }
    }
    
    private func endAnimating() {
        activityIndicatorView?.stopAnimating()
        delegate?.loadMoreControl(didStopAnimating: self)
    }
}
