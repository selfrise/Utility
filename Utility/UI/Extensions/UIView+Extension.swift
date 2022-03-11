//
//  UIView+Extension.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import UIKit

public extension UIView {
    
    func constraints(with: [ConstraintAnchors]) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = with.map { (anchor) -> NSLayoutConstraint in
            switch anchor {
            case .width(let constant):
                return widthAnchor.constraint(equalToConstant: constant)
            case .height(let constant):
                return heightAnchor.constraint(equalToConstant: constant)
            case .left(let equalTo, let constant):
                return leftAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .right(let equalTo, let constant):
                return rightAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .top(let equalTo, let constant):
                return topAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .bottom(let equalTo, let constant):
                return bottomAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .centerX(let equalTo, let constant):
                return centerXAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .centerY(let equalTo, let constant):
                return centerYAnchor.constraint(equalTo: equalTo, constant: constant ?? 0)
            case .widthDimension(let width, let multiplier):
                return widthAnchor.constraint(equalTo: width, multiplier: multiplier ?? 1)
            case .heightDimension(let height, let multiplier):
                return heightAnchor.constraint(equalTo: height, multiplier: multiplier ?? 1)
            }
        }
        
        return constraints
    }
    
    func fit(subView: UIView, padding: UIEdgeInsets = .zero) {
        if subView.superview != self {
            addSubview(subView)
        }
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left))
        constraints.append(subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right))
        constraints.append(subView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top))
        constraints.append(subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerOfView(subView: UIView) {
        if subView.superview != self {
            addSubview(subView)
        }
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(subView.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(subView.centerYAnchor.constraint(equalTo: centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UIActivityIndicatorView

extension UIView {
    private static let indicatorViewKey = "IndicatorView"
    
    func setLoading(_ show: Bool) {
        if show {
            if subviews.contains(where: { $0.accessibilityIdentifier == UIView.indicatorViewKey }) {
                return
            }
            
            let indicatorView = UIActivityIndicatorView(style: .large)
            indicatorView.accessibilityIdentifier = UIView.indicatorViewKey
            centerOfView(subView: indicatorView)
            indicatorView.startAnimating()
        } else {
            if let indicatorView = subviews.first(where: { $0.accessibilityIdentifier == UIView.indicatorViewKey }) as? UIActivityIndicatorView {
                indicatorView.stopAnimating()
                indicatorView.removeFromSuperview()
            }
        }
    }
}
