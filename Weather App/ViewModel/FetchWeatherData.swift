//
//  FetchWeatherData.swift
//  Weather App
//
//  Created by Mahedee Zaman on 12/5/22.
//

import Foundation

class FetchWeatherData {
    static let sharedInstance = FetchWeatherData()
    
    enum APIError : Error {
        case error(_ errorString : String)
    }
    
    func getJSON<T: Decodable>(
        urlString : String,
        dateDecodingStrategy : JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, APIError>) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(.failure(.error("Error: Invalid URL")))
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.error("Error: \(error.localizedDescription)")))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.error("Error: Data is corrupted")))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = keyDecodingStrategy
                decoder.dateDecodingStrategy = dateDecodingStrategy
                
                do{
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                    return
                } catch let decodingError {
                    completion(.failure(.error("Error: \(decodingError.localizedDescription)")))
                    return
                }
                
            }.resume()
        }
}
