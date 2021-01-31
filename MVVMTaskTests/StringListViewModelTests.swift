//
//  StringListViewModelTests.swift
//  MVVMTaskTests
//
//  Created by Nataliya Murauyova on 11/22/20.
//
@testable import MVVMTask
import XCTest

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

        let alertView = viewModel.errorAlertView(for: NetworkManagerError.noURL) { _ in }

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

    func testSortStrings_FromAToZ() {
        let dataSource = StringList(strings: ["bcd", "cFgsd", "abc"])
        let viewModel = StringListViewModel()
        viewModel.dataSource = dataSource

        viewModel.sortStrings(basedOn: .fromAToZ)

        XCTAssertEqual(viewModel.dataSource?.strings, ["abc", "bcd", "cFgsd"])
    }

    func testSetInitialStringList() {
        let viewModel = StringListViewModel()
        let networkManager = MockNetworkManager()
        networkManager.stringsArray = StringList(strings: ["bcd", "cFgsd", "abc"])
        viewModel.networkManager = networkManager

        let exp = expectation(description: #function)
        viewModel.loadStrings(from: "https://validURL.com") { (error) in
            XCTAssertNotNil(viewModel.dataSource)
            XCTAssertEqual(viewModel.dataSource?.strings, ["bcd", "cFgsd", "abc"])
            XCTAssertNil(error)

            viewModel.sortStrings(basedOn: .asIs)
            XCTAssertEqual(viewModel.dataSource?.strings, ["bcd", "cFgsd", "abc"])

            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testSortStrings_FromZToA() {
        let dataSource = StringList(strings: ["bcd", "cFgsd", "abc"])
        let viewModel = StringListViewModel()
        viewModel.dataSource = dataSource

        viewModel.sortStrings(basedOn: .fromZToA)

        XCTAssertEqual(viewModel.dataSource?.strings, ["cFgsd", "bcd", "abc"])
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    var stringsArray: StringList?
    var error: Error?
    func getStrings(from url: URL, with completion: @escaping (StringList?, Error?) -> Void) {
        completion(stringsArray, error)
    }
}
