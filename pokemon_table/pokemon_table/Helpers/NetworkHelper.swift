//
//  NetworkHelper.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation
import UIKit

public class NetworkHelper: NSObject, Networking {
    
    // MARK: -
    // MARK: Variables
    
    private var session = URLSession.shared
    private var dataTasks: [URLSessionDataTask] = []
    
    // MARK: -
    // MARK: Initialization
    
    public init(session: URLSession) {
        self.session = session
    }
    
    // MARK: -
    // MARK: Public
    
    @discardableResult
    public func data<DataType: Codable>(
        dataType: DataType.Type,
        url: URL,
        completion: @escaping NetworkResponse<DataType>) -> URLSessionDataTask
    {
        
        let task = self.session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            do {
                let decodedJson = try JSONDecoder().decode(DataType.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedJson))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
        self.dataTasks.append(task)
        
        return task
    }
    
    @discardableResult
    public func image(url: URL, completion: @escaping NetworkResponse<Data>) -> URLSessionDataTask {
        let task = self.session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        
        task.resume()
        self.dataTasks.append(task)
        
        return task
    }
    
    public func cancel(task: URLSessionDataTask) {
        guard let index = self.dataTasks.firstIndex(where: { $0 == task }) else {
            return
        }
        self.dataTasks[index].cancel()

        self.dataTasks.remove(at: index)
    }
}

extension NetworkHelper: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let index = self.dataTasks.firstIndex(where: { $0 == dataTask }) else {
            return
        }
        
        self.dataTasks.remove(at: index)
    }
}
