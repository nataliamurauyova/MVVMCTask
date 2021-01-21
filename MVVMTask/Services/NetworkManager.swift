//
//  NetworkManager.swift
//  MVVMTask
//
//  Created by Nataliya Murauyova on 11/21/20.
//

import Foundation
enum NetworkManagerError: Error {
    case cantParseStringsArray
    case noURL
}

protocol NetworkManagerProtocol {
    func getStrings(from url: URL, with completion: @escaping (StringList?, Error?) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getStrings(from url: URL, with completion: @escaping (StringList?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let stringList = self?.parse(data) {
                    completion(stringList, nil)
                } else {
                    completion(nil, NetworkManagerError.cantParseStringsArray)
                }

            }
        }

        task.resume()
    }

    private func parse(_ data: Data?) -> StringList? {
        guard let data = data,
              let convertedData = String(data: data, encoding: .utf8) else { return nil }

        let arrayOfStrings = convertedData.split(separator: "\n")

        return StringList(strings: arrayOfStrings.map { String($0) })
    }
}
