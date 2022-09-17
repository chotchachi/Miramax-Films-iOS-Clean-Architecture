//
//  Resolver+resolverOrThrow.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Swinject

extension Resolver {
    public func resolve<T>() -> T {
        guard let resolvedType = resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        
        return resolvedType
    }
}
