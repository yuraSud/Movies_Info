//
//  BaseCoordinator.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import UIKit

class BaseCoordinator: NSObject, CoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    var type: CoordinatorType
    
    func start() {}
    
    required init(_ navigationController: UINavigationController, type: CoordinatorType) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: true)
        self.type = type
    }
}
