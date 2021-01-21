//
//  AppCoordinator.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

import Foundation
import UIKit
protocol AppCoordinatorProtocol {
    func prepareStringsViewController(_ vc: StringListViewController)
    func configureInitialNavigationController() -> UINavigationController?
    func showAlert(_ alertVC: UIAlertController, on parentVC: UIViewController)
}

class AppCoordinator: AppCoordinatorProtocol {
    func prepareStringsViewController(_ vc: StringListViewController) {
        let viewModel = StringListViewModel()
        viewModel.networkManager = NetworkManager()
        vc.viewModel = viewModel
        vc.coordinator = AppCoordinator()
    }

    func configureInitialNavigationController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil)
        if let initialViewController = storyboard.instantiateViewController(withIdentifier: Constants.loginVCIdentifier) as? LoginViewController {
            initialViewController.viewModel = LoginViewModel()
            initialViewController.coordinator = AppCoordinator()
            return UINavigationController(rootViewController: initialViewController)
        } else {
            return UINavigationController()
        }
    }

    func showAlert(_ alertVC: UIAlertController, on parentVC: UIViewController) {
        parentVC.present(alertVC, animated: true, completion: nil)
    }
}
