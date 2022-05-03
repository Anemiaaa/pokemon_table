//
//  Operators.swift
//  Network Service
//
//  Created by IDAP Developer on 12/3/19.
//  Copyright © 2019 Bendis. All rights reserved.
//

import Foundation

public typealias ModelHandlerType<ModelType: NetworkProcessable>
    = ModelHandler<Result<ModelType.ReturnedType, Error>>

public typealias HTTPMethod<ModelType: NetworkProcessable, Service: SessionService>
    = (Request<ModelType, Service>) -> Task?

@discardableResult
public func get <ModelType: NetworkProcessable, Service>(
    modelHandler: @escaping ModelHandlerType<ModelType>
)
    -> ((Request<ModelType, Service>) -> Task?) where Service.DataType == ModelType.DataType
{
    lift(modelHandler: modelHandler, requestType: .get)
}

@discardableResult
public func post <ModelType: NetworkProcessable, Service>(
    modelHandler: @escaping ModelHandlerType<ModelType>
)
    -> ((Request<ModelType, Service>) -> Task?) where Service.DataType == ModelType.DataType
{
    lift(modelHandler: modelHandler, requestType: .post)
}

@discardableResult
public func del <ModelType: NetworkProcessable, Service>(
    modelHandler: @escaping ModelHandlerType<ModelType>
)
    -> ((Request<ModelType, Service>) -> Task?) where Service.DataType == ModelType.DataType
{
    lift(modelHandler: modelHandler, requestType: .delete)
}

@discardableResult
public func put <ModelType: NetworkProcessable, Service>(
    modelHandler: @escaping ModelHandlerType<ModelType>
)
    -> ((Request<ModelType, Service>) -> Task?) where Service.DataType == ModelType.DataType
{
    
    lift(modelHandler: modelHandler, requestType: .put)
}

private func lift <ModelType: NetworkProcessable, Service>(
    modelHandler: @escaping ModelHandlerType<ModelType>,
    requestType: RequestType
)
    -> ((Request<ModelType, Service>) -> Task?) where Service.DataType == ModelType.DataType
{
    curry(flip(task))(requestType)(modelHandler)
}

private func task<ModelType: NetworkProcessable, Service>(
    request: Request<ModelType, Service>,
    modelHandler: @escaping ModelHandler<Result<ModelType.ReturnedType, Error>>,
    requestType: RequestType
)
    -> Task? where Service.DataType == ModelType.DataType
{
    var mutable = request
    
    mutable.type = requestType
    
    let data = (Service.self |+| mutable)
    
    data.0.handler = { result in
        let value = try? result.get()
        let string = value.map { String(data: $0, encoding: .utf8) }
        
        modelHandler(
            string == EmptyTaskDataValue
                ? ModelType.initialize(with: result)
                : ModelType.dataInitialize(with: result)
        )
    }
    
    data.0.task?.resume()
    
    return data.0.task
}

public extension SessionService {
    
    static func request<ModelType>(
        model: ModelType.Type,
        url: URL? = nil
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        if let url = url ?? model.url {
            return Request(modelType: model, url: url)
        }
        fatalError("didnt get url in request function")
    }
    
    static func request<ModelType, Params: QueryParamsType>(
        model: ModelType.Type,
        params: Params
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        self.request(model: model, params: params, url: nil)
    }
    
    static func request<ModelType, Params: QueryParamsType>(
        model: ModelType.Type,
        params: Params,
        url: URL? = nil
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        let encoder = JSONEncoder()
        let data = (try? encoder.encode(params)) ?? Data()
        
        let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String : Any]
        
        if var url = url ?? model.url {
            url = url +? (dictionary ?? [:])
            
            return Request(modelType: model, url: url)
        }
        fatalError("didnt get url in request function")
    }
    
    static func request<ModelType, Params: BodyParamsType>(
        model: ModelType.Type,
        params: Params
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        self.request(model: model, params: params, type: .formdata)
    }
    
    static func request<ModelType, Params: BodyParamsType>(
        model: ModelType.Type,
        params: Params,
        type: RequestDataType = .formdata
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        self.request(model: model, params: params, url: nil, type: type)
    }
    
    static func request<ModelType, Params: BodyParamsType>(
        model: ModelType.Type,
        params: Params,
        url: URL? = nil,
        type: RequestDataType = .formdata
    )
        -> Request<ModelType, Self> where ModelType: NetworkProcessable
    {
        let encoder = JSONEncoder()
    
        let data = (try? encoder.encode(params)) ?? Data()
    
        var dictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String : Any]
        dictionary?.merge(params.rawValues) { (_, new) in new }
    
        let encoded = type == .formdata ? dictionary?.multipartRequestConverted() ?? data : data
        
        if let url = url ?? model.url {
            return Request(modelType: model, url: url, body: encoded, contentType: type.rawValue)
        }
        fatalError("didnt get url in request function")
    }
}

public enum RequestDataType: String {
    
    case json = "application/json"
    case formdata = "multipart/form-data; boundary=nori netwrok layer"
}
/// Combine model/request/params with service
infix operator |+|: MultiplicationPrecedence
@discardableResult
internal func |+| <Session: SessionService, Model: NetworkProcessable> (
    session: Session.Type,
    request: Request<Model, Session>
)
    -> NetworkOperationComposingResult<Model.DataType, Model.Type> where Session.DataType == Model.DataType
{
    let handlerContainer = TaskExecutableDataHandler<Model.DataType>(handler: nil, task: nil)
    
    let task = session.dataTask(request: request) {
        handlerContainer.handler?($0)
    }
    
    handlerContainer.task = task
    
    return (handlerContainer, Model.self)
}

public typealias HTTPCombineResult<ModelType: NetworkProcessable>
    = (@escaping (Result<ModelType.ReturnedType, Error>) -> ()) -> Task?

/// Combine request with http method
infix operator |*|: AdditionPrecedence

@discardableResult
public func |*| <ModelType, Service>(
    request: Request<ModelType, Service>,
    method: @escaping HTTPMethod<ModelType, Service>
)
    -> Task?
{
    return method(request)
}

@discardableResult
public func |*| <ModelType: NetworkProcessable, Service> (
    model: ModelType.Type,
    method: @escaping HTTPMethod<ModelType, Service>
)
    -> Task?
{
    if let url = model.url {
        let request = Request<ModelType, Service>(modelType: model, url: url)
        return method(request)
    }
    fatalError("didnt get url in request function")
}
