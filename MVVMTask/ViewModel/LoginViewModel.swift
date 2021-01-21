//
//  LoginViewModel.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

protocol LoginViewModelProtocol {
    func credentialsValidation(email: String, password: String) -> CredentialValidation
    func areCredentialsValid(_ validation: CredentialValidation) -> Bool
}
typealias CredentialValidation = (emailValid: Bool, passwordValid: Bool)
class LoginViewModel: LoginViewModelProtocol {

    func credentialsValidation(email: String, password: String) -> CredentialValidation {
        return (email == Constants.correctEmail, password == Constants.correctPassword)
    }

    func areCredentialsValid(_ validation: CredentialValidation) -> Bool {
        return validation.emailValid && validation.passwordValid
    }
}
