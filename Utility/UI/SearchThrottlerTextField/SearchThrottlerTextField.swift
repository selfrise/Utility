//
//  SearchThrottlerTextField.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import UIKit

public final class SearchThrottlerTextField: UITextField {
    
    deinit {
        self.removeTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
    }
    
    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: ((String?) -> Void)? = nil
    
    public func throttle(delay: Double, callback: @escaping ((String?) -> Void)) {
        self.delay = delay
        self.callback = callback
        DispatchQueue.main.async {
            self.callback?(self.text)
        }
        self.addTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        if self.workItem == nil {
            let text = sender.text
            self.callback?(text)
            let workItem = DispatchWorkItem(block: { [weak self] in
                self?.workItem?.cancel()
                self?.workItem = nil
                if text != sender.text {
                    self?.callback?(sender.text)
                }
            })
            self.workItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
}
