//
//  Service.swift
//  pokemon_table
//
//  Created by Yana on 10/04/2022.
//

import Foundation

public protocol URLContainable {

    static var url: URL { get }
}

public protocol Headers: Encodable {

    var dictionary: [String : String] { get }
}

public protocol Task {

    func resume()
    func cancel()
}

public class UrlSessionTask: Task {

    private let task: URLSessionDataTask

    public init(task: URLSessionDataTask) {
        self.task = task
    }

    public func resume() {
        self.task.resume()
    }

    public func cancel() {
        self.task.cancel()
    }
}

public enum UrlSessionServiceError: Error {

    case unknown
}

private let erorrsStatusCodes = (400...599)

public struct EmptyHeaders: Headers {
    public var dictionary: [String : String]

    public init() {
        self.dictionary = [:]
    }
}

final public class UrlSessionService: NetworkService {

    public static var headers: Headers = EmptyHeaders() {
        didSet {
            self.prevHeaders = oldValue
        }
    }

    public static var tokenDidInvalidate: (() -> ())?

    private static var session = URLSession(configuration: URLSession.shared.configuration)
    private static var firstRun = true

    private static var prevHeaders: Headers = EmptyHeaders()

    public static func dataTask<ModelType: NetworkProcessable>(
        url: URL,
        modelType: ModelType.Type,
        completion: @escaping NetworkResponse<ModelType.ReturnedType>
    )
        -> Task
    {
        self.dataTask(url: url) { dataResult in
            completion(ModelType.initialize(with: dataResult))
        }
    }
    
    public static func dataTask(url: URL, completion: @escaping NetworkResponse<Data>) -> Task {
        if firstRun || prevHeaders.dictionary != headers.dictionary {
            let configuration = session.configuration
            configuration.httpAdditionalHeaders = headers.dictionary
            session = URLSession(configuration: configuration)
            firstRun = false
            prevHeaders = headers
        }

        let dataTask = self.session.dataTask(with: url) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, let _ = data {
                switch statusCode {
                case 401:
                    self.tokenDidInvalidate?()
                default:
                    break
                }
            }

            let result: NetworkResult = data.map { .success($0) }
                ?? error.map { .failure($0) }
                ?? .failure(UrlSessionServiceError.unknown)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = UrlSessionTask(task: dataTask)
        
        task.resume()

        return task
    }
}
