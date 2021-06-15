//
//  BaseCoordinator.swift
//  TrackerRoute
//
//  Created by Rayen on 15.06.2021.
//

import UIKit

// Абстрактный класс-координатор
class BaseCoordinator {

    var childCoordinators: [BaseCoordinator] = []

    func start() {
        // Переопределить в наследниках
    }

    func addDependency(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func setAsRoot(_ controller: UIViewController) {
        if #available(iOS 14, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = controller
        } else {
            UIApplication.shared.keyWindow?.rootViewController = controller
        }
    }
}
