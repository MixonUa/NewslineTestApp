//
//  NetworkFetchService.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import Foundation

class NetworkFetchService {
    private let networkDataProvider: NetworkManager
    
    init(networkDataProvider: NetworkManager = NetworkManager()) {
        self.networkDataProvider = networkDataProvider
    }
    
    func requestAllNews(completion: @escaping (NewsFeedModel?, Error?) -> Void) {
        let newsURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
        networkDataProvider.requestData(urlString: newsURL) { (data, error) in
            guard let data = data else { return }
            do {
                let answer = try JSONDecoder().decode(NewsFeedModel.self, from: data)
                DispatchQueue.main.async {
                    completion(answer, nil)
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(nil, decodingError)
                }
            }
        }
    }
    
    func requestDetailedNew(by id: Int, completion: @escaping (DetailedNewsModel?, Error?) -> Void) {
        let newsURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json"
        networkDataProvider.requestData(urlString: newsURL) { (data, error) in
            guard let data = data else { return }
            do {
                let answer = try JSONDecoder().decode(DetailedNewsModel.self, from: data)
                DispatchQueue.main.async {
                    completion(answer, nil)
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(nil, decodingError)
                }
            }
        }
    }
}
