//
//  Coordinator.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import UIKit

protocol CoordinatorProtocol: NSObject {
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
    func start()
    
    init(_ navigationController: UINavigationController, type: CoordinatorType)
    
}

extension CoordinatorProtocol {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self.type)
    }
}

// MARK: - CoordinatorOutput

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: CoordinatorType)
}

// MARK: - CoordinatorType

enum CoordinatorType {
    case app, login, tab
}
