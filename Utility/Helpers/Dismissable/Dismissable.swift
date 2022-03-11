//
//  Dismissable.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

protocol Dismissable {
    /// Dismisses the activity.
    func dismiss()
}

extension Dismissable {
    /// The return value should be held, otherwise it will be dismissed.
    func sink() -> AnyCancellable {
        AnyCancellable(dismiss)
    }
}
