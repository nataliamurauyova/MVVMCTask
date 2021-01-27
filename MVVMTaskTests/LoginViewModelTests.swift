//
//  LoginViewModelTests.swift
//  MVVMTaskTests
//
//  Created by Nataliya Murauyova on 11/22/20.
//
@testable import MVVMTask
import XCTest

class LoginViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCredentialsValidation_Success() throws {
        let viewModel = LoginViewModel()

        let credValidation = viewModel.credentialsValidation(email: "user", password: "123qwe")

        XCTAssertTrue(credValidation.emailValid)
        XCTAssertTrue(credValidation.passwordValid)
    }

    func testCredentialsValidation_Failure_WrongEmail() throws {
        let viewModel = LoginViewModel()

        let credValidation = viewModel.credentialsValidation(email: "useeeer", password: "123qwe")

        XCTAssertFalse(credValidation.emailValid)
        XCTAssertTrue(credValidation.passwordValid)
    }

    func testCredentialsValidation_Failure_WrongPassword() throws {
        let viewModel = LoginViewModel()

        let credValidation = viewModel.credentialsValidation(email: "user", password: "password")

        XCTAssertTrue(credValidation.emailValid)
        XCTAssertFalse(credValidation.passwordValid)
    }

    func testAreCredentialsValid_True() {
        let viewModel = LoginViewModel()

        let areCredsValid = viewModel.areCredentialsValid(viewModel.credentialsValidation(email: "user", password: "123qwe"))

        XCTAssertTrue(areCredsValid)
    }

    func testAreCredentialsValid_False_wrongEmail() {
        let viewModel = LoginViewModel()

        let areCredsValid = viewModel.areCredentialsValid(viewModel.credentialsValidation(email: "useeeeer", password: "123qwe"))

        XCTAssertFalse(areCredsValid)
    }

    func testAreCredentialsValid_False_wrongPassword() {
        let viewModel = LoginViewModel()

        let areCredsValid = viewModel.areCredentialsValid(viewModel.credentialsValidation(email: "user", password: "123qweeeeee"))

        XCTAssertFalse(areCredsValid)
    }

    func testAreCredentialsValid_False_wrongEmailPassword() {
        let viewModel = LoginViewModel()

        let areCredsValid = viewModel.areCredentialsValid(viewModel.credentialsValidation(email: "useeeer", password: "123qweeeeee"))

        XCTAssertFalse(areCredsValid)
    }
}
