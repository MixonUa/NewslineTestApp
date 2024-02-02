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
    
    func requestAllNews(completion: @escaping (Result<NewsFeedModel, Error>) -> Void) {
        let newsURL = "https://raw.githubusercontent.com/MixonUa/JSON-NewslineTestApp/main/main.json"
        networkDataProvider.requestData(urlString: newsURL) { (data, error) in
            if let error = error { completion(.failure(NetworkError.serverError(error: error))); return }
            if let data = data {
                do {
                    let answer = try JSONDecoder().decode(NewsFeedModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(answer))
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                        completion(.failure(decodingError))
                    }
                }
            }
        }
    }
    
    func requestDetailedNew(id: Int, completion: @escaping (Result<DetailedNewsModel, Error>) -> Void) {
        let newsURL = "https://raw.githubusercontent.com/MixonUa/JSON-NewslineTestApp/main/posts/\(id).json"
        networkDataProvider.requestData(urlString: newsURL) { (data, error) in
            if let error = error { completion(.failure(NetworkError.serverError(error: error))); return }
            if let data = data {
                do {
                    let answer = try JSONDecoder().decode(DetailedNewsModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(answer))
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                        completion(.failure(decodingError))
                    }
                }
            }
        }
    }
}
