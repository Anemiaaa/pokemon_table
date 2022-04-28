//
//  Operators.swift
//  pokemon_table
//
//  Created by Yana on 21/04/2022.
//

import Foundation

public typealias HTTPMethod<ModelType: NetworkProcessable, Service: NetworkService>
    = (Request<ModelType, Service>) -> Task?

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
    let request = Request<ModelType, Service>(modelType: model, url: model.url)
    return method(request)
}

