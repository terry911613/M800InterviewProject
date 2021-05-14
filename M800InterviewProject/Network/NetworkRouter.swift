//
//  NetworkRouter.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import Foundation

public class NetworkRouter {
    
    private struct Response<T: Codable>: Codable {
        let results: T
    }
    
    public static func request<T: Codable>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    if let data = data {
                        print(String(data: data, encoding: .utf8) ?? "")
                        let decoder = JSONDecoder()
                        do {
                            let response = try decoder.decode(Response<T>.self, from: data)
                            completion(.success(response.results))
                        }
                        catch {
                            completion(.failure(error))
                        }
                    }
                    else {
                        completion(.failure(AppError.dataNil))
                    }
                }
            }
        }
        task.resume()
    }
}
