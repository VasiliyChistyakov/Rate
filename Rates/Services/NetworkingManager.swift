//
//  NetworkingManager.swift
//  Valuta
//
//  Created by Чистяков Василий Александрович on 18.09.2021.
//

import Foundation
import UIKit

final class NetworkingManager: APIService {
	static let shared: APIService = NetworkingManager()
  
	private init() { }
    
    func fetchRates(urlJson: String, complitionHandler: @escaping (Result<MainExchangeRates,Error>) -> Void ){
        guard let url = URL(string: urlJson) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            print(data)
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try decoder.decode(MainExchangeRates.self, from: data)
                complitionHandler(.success(json))
            } catch let error as NSError {
                complitionHandler(.failure(error))
                print(error.localizedDescription)
            }
        }.resume()
    }
}
