//
//  StringListViewModel.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

import UIKit

protocol StringListViewModelProtocol: UITableViewDataSource {
    var networkManager: NetworkManagerProtocol! { get set }
    var dataSource: StringList? { get set }
    func loadStrings(from url: String, with completion: @escaping (Error?) -> Void)
    func configure(tableView: UITableView)
    func sortStrings(basedOn index: SelectedIndex)
    func errorAlertView(for error: Error, with handler: @escaping (UIAlertAction) -> Void) -> UIAlertController
}

enum SelectedIndex: Int {
    case asIs = 0
    case fromAToZ
    case fromZToA
}

class StringListViewModel: NSObject, StringListViewModelProtocol {

    var networkManager: NetworkManagerProtocol!
    var dataSource: StringList?

    private var initialStringList: StringList?

    func loadStrings(from url: String, with completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: url) else {
            completion(NetworkManagerError.noURL)
            return
        }

        networkManager.getStrings(from: url) { [weak self] (stringList, error) in
            self?.dataSource = stringList
            self?.initialStringList = stringList
            completion(error)
        }
    }

    func sortStrings(basedOn index: SelectedIndex) {
        switch index {
        case .fromAToZ:
            let sortedStrings = dataSource?.strings.sorted { $0 < $1 } ?? []
            dataSource = StringList(strings: sortedStrings)
        case .fromZToA:
            let sortedStrings = dataSource?.strings.sorted { $0.lowercased() > $1.lowercased() } ?? []
            dataSource = StringList(strings: sortedStrings)
        case .asIs:
            dataSource = initialStringList
        }
    }

    func configure(tableView: UITableView) {
        tableView.dataSource = self
    }

    func errorAlertView(for error: Error, with handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertView = UIAlertController(title: "\(Constants.errorAlertTitle) - \(error.localizedDescription)", message: Constants.errorAlertMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: Constants.errorAction, style: .cancel, handler: handler))
        return alertView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.strings.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = dataSource?.strings[indexPath.row]
        return cell
    }
}
