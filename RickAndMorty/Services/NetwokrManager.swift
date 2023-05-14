//
//  NetwokrManager.swift
//  RickAndMorty
//
//  Created by Khusain on 13.05.2023.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: String?, with completion: @escaping(Result<T, AFError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL(url: url ?? "")))
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON {dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    var result: T

                    switch T.self {
                    case is RickAndMorty.Type:
                        result = RickAndMorty.getRickAndMorty(from: value) as! T
                    case is Character.Type:
                        result = Character.getCharacter(from: value) as! T
                    default:
                        result = Episode.getEpisode(from: value) as! T
                    }
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchImage(from url: String?, with completion: @escaping (Result<Data, AFError>) -> Void) {
        
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL(url: url ?? "")))
            return
        }
        
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
}
