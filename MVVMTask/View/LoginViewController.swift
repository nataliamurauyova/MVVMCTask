//
//  LoginViewController.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

import UIKit

protocol LoginViewProtocol {
    func setErrorState(basedOn validation: CredentialValidation)
}

class LoginViewController: UIViewController, LoginViewProtocol {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var coordinator: AppCoordinatorProtocol!
    var viewModel: LoginViewModelProtocol!

    @IBAction func loginButtonPressed(_ sender: Any) {
        let validation = viewModel.credentialsValidation(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        if viewModel.areCredentialsValid(validation){
            performSegue(withIdentifier: Constants.stringsVCSegueIdentifier, sender: self)
        } else {
            setErrorState(basedOn: validation)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (Constants.stringsVCSegueIdentifier, let vc as StringListViewController) :
            coordinator.prepareStringsViewController(vc)
        default:
            break
        }
    }

    func setErrorState(basedOn validation: CredentialValidation) {
        if !validation.emailValid {
            setRedCorner(for: emailTextField)
        }

        if !validation.passwordValid {
            setRedCorner(for: passwordTextField)
        }
    }

    private func setRedCorner(for textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 5.0
    }
}
