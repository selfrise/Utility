//
//  AnyCancellable.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

/// A type-erasing cancellable object that executes a provided closure when canceled.
///
/// An ``AnyCancellable`` instance automatically calls ``Cancellable/cancel()`` when deinitialized.
public final class AnyCancellable: Cancellable, Hashable {
    
    typealias CancelAction = () -> Void
    
    private var cancelAction: CancelAction?
    
    /// Initializes the cancellable object with the given cancel-time closure.
    ///
    /// - Parameter cancel: A closure that the `cancel()` method executes.
    init(_ cancel: @escaping CancelAction) {
        self.cancelAction = cancel
    }
    
    init<C>(_ canceller: C) where C: Cancellable {
        cancelAction = canceller.cancel
    }
    
    /// When deallocated the object then call cancel-time closure to cancel operation.
    deinit {
        cancel()
    }
    
    public func cancel() {
        cancelAction?()
        cancelAction = nil
    }
    
    public func store(in set: inout Set<AnyCancellable>) {
        set.insert(self)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: AnyCancellable, rhs: AnyCancellable) -> Bool {
        lhs === rhs
    }
}
