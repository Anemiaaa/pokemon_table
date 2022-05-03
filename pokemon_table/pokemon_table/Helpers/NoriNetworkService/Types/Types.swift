//
//  Types.swift
//  Network Service
//
//  Created by IDAP Developer on 12/3/19.
//  Copyright © 2019 Bendis. All rights reserved.
//

import Foundation

public typealias ModelHandler<Type> = (Type) -> ()

public typealias NetworkOperationComposingResult<DataType, ModelType> = (TaskExecutableDataHandler<DataType>, ModelType)

public protocol URLContainable {
    
    static var url: URL? { get }
}

extension URLContainable {
    
    public static var url: URL? {
        return nil
    }
}

public protocol DataInitiable {
    
    typealias DataType = Data
}

public protocol NetworkModel: DataInitiable, Codable {
    
}

public protocol DataSessionService: SessionService where DataType == Data {
    
}

public protocol NetworkProcessable: URLContainable, NetworkModel {
    
    associatedtype ReturnedType: Codable = Self
    
    /// Implement for rewrite requests parsing
    static func dataInitialize(with data: Result<Data, Error>) -> Result<ReturnedType, Error>
        
    /// Implement for mock requests
    static func initialize(with data: Result<DataType, Error>) -> Result<ReturnedType, Error>
}

public protocol Task {
   
    func resume()
    func cancel()
}

public protocol SessionService {
    
    associatedtype DataType
    
    typealias ResultedDataType = Result<DataType, Error>
    typealias DataTypeHandler = (ResultedDataType) -> ()
    
    static func dataTask<ModelType: NetworkProcessable>(
        request: Request<ModelType, Self>,
        completion: @escaping DataTypeHandler
    ) -> Task
}

public protocol Headers: Encodable {
    
    var dictionary: [String : String] { get }
}

public protocol QueryParamsType: Encodable { }

public protocol BodyParamsType: Encodable {
    
    var rawValues: [String : Any] { get set }
}

public extension BodyParamsType {
    
    var contentType: String {
        return "application/json; charset=UTF-8"
    }
    
    var rawValues: [String : Any] {
        get {
            return [:]
        }
        
        set {
            fatalError("Implement in object to use")
        }
    }
}

public struct File: Codable {
    
    let name: String
    let fileExtension: String
    let fileData: Data
    
    public init(name: String, fileExtension: String, fileData: Data) {
        self.name = name
        self.fileExtension = fileExtension
        self.fileData = fileData
    }
    
    internal init?(dict: Any) {
        let dict = dict as? [String : String]
        
        guard let dict = dict,
              let name = dict["name"],
              let ext = dict["fileExtension"],
              let data = dict["fileData"]?.data(using: .utf8)
        else {
            return nil
        }
                    
        self.name = name
        self.fileExtension = ext
        self.fileData = data
    }
}

