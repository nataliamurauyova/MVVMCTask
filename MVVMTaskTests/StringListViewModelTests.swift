//
//  StringListViewModelTests.swift
//  MVVMTaskTests
//
//  Created by Nataliya Murauyova on 11/22/20.
//

import XCTest
@testable import MVVMTask

class StringListViewModelTests: XCTestCase {

    func testLoadStrings_Success() throws {
        let viewModel = StringListViewModel()
        let networkManager = MockNetworkManager()
        networkManager.stringsArray = StringList(strings: ["string1", "string2"])
        viewModel.networkManager = networkManager

        let exp = expectation(description: #function)
        viewModel.loadStrings(from: "https://validURL.com") { (error) in
            XCTAssertNotNil(viewModel.dataSource)
            XCTAssertEqual(viewModel.dataSource?.strings, ["string1", "string2"])
            XCTAssertNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testLoadStrings_Failure() throws {
        let viewModel = StringListViewModel()
        let networkManager = MockNetworkManager()
        networkManager.error = NetworkManagerError.cantParseStringsArray
        viewModel.networkManager = networkManager

        let exp = expectation(description: #function)
        viewModel.loadStrings(from: "https://validURL.com") { (error) in
            XCTAssertNil(viewModel.dataSource)
            XCTAssertNotNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testLoadStrings_Failure_wrongURL() throws {
        let viewModel = StringListViewModel()
        let networkManager = MockNetworkManager()
        networkManager.stringsArray = StringList(strings: ["string1", "string2"])
        viewModel.networkManager = networkManager

        let exp = expectation(description: #function)
        viewModel.loadStrings(from: "") { (error) in
            XCTAssertNil(viewModel.dataSource)
            XCTAssertNotNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testConfigureTableView() {
        let viewModel = StringListViewModel()
        let tableView = UITableView()

        viewModel.configure(tableView: tableView)

        XCTAssertTrue(tableView.dataSource is StringListViewModel)
    }

    func testErrorAlertView() {
        let viewModel = StringListViewModel()

        let alertView = viewModel.errorAlertView(for: NetworkManagerError.noURL, with: { _ in })

        XCTAssertEqual(alertView.title, "Something went wrong 😔 - The operation couldn’t be completed. (MVVMTask.NetworkManagerError error 1.)")
        XCTAssertEqual(alertView.message, "Please try reloading the page")
        XCTAssertEqual(alertView.actions.count, 1)
    }

    func testNumberOfRowsInSection() {
        let dataSource = StringList(strings: ["string1", "string2"])
        let viewModel = StringListViewModel()
        viewModel.dataSource = dataSource

        let tableView = UITableView()
        let numberOfRows = viewModel.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(numberOfRows, 2)
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    var stringsArray: StringList?
    var error: Error?
    func getStrings(from url: URL, with completion: @escaping (StringList?, Error?) -> Void) {
        completion(stringsArray, error)
    }
}
