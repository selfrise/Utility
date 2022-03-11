//
//  CoordinatorProtocol.swift
//  Utility
//
//  Created by Tolga YILDIRIM on 11.03.2022.
//

import UIKit

/// A Coordinator represents a type that connects the flows between viewcontrollers.
/// Responsibilities of a Coordinator could be implementing delegates and closures of UIViewControllers and pushing them on the navigation stack.
///
/// A Coordinator creates its own navigationcontainer, represented by the associatedtype NavigationContainer, which owns the viewcontrollers in the flow.
/// The NavigationContainer could for instance be a UINavigationController, or UITabbarController, or a custom type, etc.
///
/// To prevent the use of singletons, a Coordinator can externally receive a type containing its necessary dependencies. As indicated by the Dependencies associatedtype.
/// These dependencies could be a real/mock network layer, a usersession, localstorage, analytics, error handler etc.
/// By obtaining them from the parent, viewcontrollers don't need to reach for singletons to obtain dependencies, this way we avoid some tight-coupling.
///
/// A Coordinator can also create other Coordinators, allowing for more complex flows.
protocol CoordinatorProtocol: Dismissable, ParentCoordinatorDelegate {
    /// The parent coordinator that created the current coordinator.
    var parentCoordinator: ParentCoordinatorDelegate? { get set }
    
    /// Start should supply the NavigationContainer UIViewController that will contain other viewcontrollers.
    /// The parent can decide how to present this.
    func start()
}

protocol ParentCoordinatorDelegate: AnyObject {
    /// Child coordinators created by current coordinator
    var children: [CoordinatorProtocol] { get set }
    
    /// Finish the child coordinator.
    /// - Parameter coordinator: The child coordinator that currently in the children stack.
    func childDidFinish(coordinator: CoordinatorProtocol)
}


// MARK: - CoordinatorProtocol

extension CoordinatorProtocol {
    
    func dismiss() {
        parentCoordinator?.childDidFinish(coordinator: self)
    }
}

// MARK: - ParentCoordinatorDelegate

extension ParentCoordinatorDelegate {
    
    func childDidFinish(coordinator: CoordinatorProtocol) {
        children = children.filter { $0 !== coordinator }
    }
}
