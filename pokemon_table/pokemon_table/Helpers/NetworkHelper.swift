//
//  NetworkHelper.swift
//  pokemon_table
//
//  Created by mac on 13.01.2022.
//

import Foundation
import UIKit

final public class NetworkHelper: NetworkService {
    
    // MARK: -
    // MARK: Variables
    
    private static var session = URLSession.shared
    
    // MARK: -
    // MARK: Public
    
    public static func dataTask<ModelType: NetworkProcessable>(
        url: URL,
        modelType: ModelType.Type,
        completion: @escaping NetworkResponse<ModelType.ReturnedType>
    ) -> Task
    {
        self.dataTask(url: url) { dataResult in
            completion(ModelType.initialize(with: dataResult))
        }
    }
    
    public static func dataTask(url: URL, completion: @escaping NetworkResponse<Data>) -> Task {
        let dataTask = self.session.dataTask(with: url) { data, response, error in
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
        
        let task = UrlSessionTask(task: dataTask)
        task.resume()
        
        return task
    }
}
