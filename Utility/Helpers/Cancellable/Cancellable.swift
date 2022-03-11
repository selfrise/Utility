//
//  Cancellable.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

/// A protocol indicating that an activity or action supports cancellation.
///
/// Calling ``Cancellable/cancel()`` frees up any allocated resources.
protocol Cancellable {
    /// Cancel the activity.
    func cancel()
}

extension Cancellable {
    /// Stores this cancellable instance in the specified set.
    ///
    /// - Parameter set: The set in which to store this ``Cancellable``.
    func store(in set: inout Set<AnyCancellable>) { }
}
