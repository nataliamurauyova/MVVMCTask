//
//  StringListViewController.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

import UIKit
protocol StringListViewProtocol {
    func showSpinner()
    func hideSpinner()
    func reloadData()
    func showErrorAlert(with error: Error)
}

class StringListViewController: UIViewController, StringListViewProtocol {

    @IBOutlet weak var stringsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel: StringListViewModelProtocol!
    var coordinator: AppCoordinatorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.configure(tableView: stringsTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func showSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }

    func hideSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }

    func reloadData() {
        showSpinner()
        viewModel.loadStrings(from: Constants.stringsUrl) { [weak self] (error) in
            DispatchQueue.main.async { [weak self] in
                self?.hideSpinner()
                if let error = error {
                    self?.showErrorAlert(with: error)
                } else {
                    self?.stringsTableView.reloadData()
                }
            }
        }
    }

    func showErrorAlert(with error: Error) {
        let alertView = viewModel.errorAlertView(for: error, with: { [weak self] _ in self?.reloadData() })
        coordinator.showAlert(alertView, on: self)
    }
}
