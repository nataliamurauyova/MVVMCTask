//
//  StringListViewControllerTests.swift
//  MVVMTaskTests
//
//  Created by Nataliya Murauyova on 11/22/20.
//
@testable import MVVMTask
import XCTest

class StringListViewControllerTests: XCTestCase {

    func testReloadData() {
        let view = StringListViewController()
        let viewModel = MockViewModel()
        view.viewModel = viewModel

        let spinner = UIActivityIndicatorView()
        view.spinner = spinner

        view.reloadData()

        XCTAssertTrue(viewModel.loadStringsCalled)
    }

    func testShowErrorAlert() {
        let view = StringListViewController()
        let viewModel = MockViewModel()
        view.viewModel = viewModel
        let coordinator = MockAppCoordinator()
        view.coordinator = coordinator

        view.showErrorAlert(with: NetworkManagerError.noURL)

        XCTAssertTrue(viewModel.errorAlertViewCalled)
        XCTAssertTrue(coordinator.showAlertCalled)
    }
}

class MockViewModel: NSObject, StringListViewModelProtocol {
    var networkManager: NetworkManagerProtocol!
    var dataSource: StringList?

    var loadStringsCalled = false
    var errorAlertViewCalled = false

    func loadStrings(from url: String, with completion: @escaping (Error?) -> Void) {
        loadStringsCalled = true
        completion(nil)
    }

    func configure(tableView: UITableView) {
    }

    func errorAlertView(for error: Error, with handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        errorAlertViewCalled = true
        return UIAlertController()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class MockAppCoordinator: AppCoordinatorProtocol {
    var prepareStringsViewControllerCalled = false
    var configureInitialNavigationControllerCalled = false
    var showAlertCalled = false

    func prepareStringsViewController(_ vc: StringListViewController) {
        prepareStringsViewControllerCalled = true
    }

    func configureInitialNavigationController() -> UINavigationController? {
        configureInitialNavigationControllerCalled = true
        return nil
    }

    func showAlert(_ alertVC: UIAlertController, on parentVC: UIViewController) {
        showAlertCalled = true
    }
}
