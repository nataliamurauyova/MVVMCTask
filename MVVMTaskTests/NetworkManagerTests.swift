//
//  NetworkManagerTests.swift
//  MVVMTaskTests
//
//  Created by Nataliya Murauyova on 11/22/20.
//
@testable import MVVMTask
import XCTest

class NetworkManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetStrings_Success() throws {
        let exp = expectation(description: #function)
        let url = try XCTUnwrap(URL(string: "https://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new"))

        let networkManager = NetworkManager()
        networkManager.getStrings(from: url) { (stringList, error) in
            XCTAssertNotNil(stringList)
            XCTAssertEqual(stringList?.strings.count, 10)
            XCTAssertNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testGetStrings_Failure_ParsingError() throws {
        let exp = expectation(description: #function)
        let url = try XCTUnwrap(URL(string: "http://www.humancomp.org/unichtm/maopoem.htm"))

        let networkManager = NetworkManager()
        networkManager.getStrings(from: url) { (stringList, error) in
            XCTAssertNil(stringList)
            XCTAssertNotNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testGetStrings_Failure_NoData() throws {
        let exp = expectation(description: #function)
        let url = try XCTUnwrap(URL(string: "https://www.error.com"))

        let networkManager = NetworkManager()
        networkManager.getStrings(from: url) { (stringList, error) in
            XCTAssertNil(stringList)
            XCTAssertNotNil(error)

            exp.fulfill()
        }

        wait(for: [exp], timeout: 5.0)
    }
}
