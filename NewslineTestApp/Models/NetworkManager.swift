//
//  NetworkManager.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import Foundation


class NetworkManager {
    func requestData(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                completion(data, nil)
            }
        }.resume()
    }
}
