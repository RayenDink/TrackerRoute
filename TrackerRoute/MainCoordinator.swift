//
//  MainCoordinator.swift
//  TrackerRoute
//
//  Created by Rayen on 15.06.2021.
//

import Foundation
import UIKit

final class MainCoordinator: BaseCoordinator {

    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?

    override func start() {
        showMainModule()
    }

    private func showMainModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)

        controller.onMap = { [weak self] usseles in
            self?.showMapModule(usseles: usseles)
        }

        controller.onLogout = { [weak self] in
            self?.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }

    private func showMapModule(usseles: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(ViewController.self)

        controller.usselesExampleVariable = usseles

        rootController?.pushViewController(controller, animated: true)
    }

}
