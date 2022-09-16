//
//  AppDIContainer.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    private let container = Container()
    private let assembler: Assembler
    
    init() {
        assembler = Assembler(
            [
                ConfigurationAssembly(),
                DataSourceAssembly(),
                NetworkAssembly(),
                ProviderAssembly()
            ],
            container: container
        )
    }
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
    
    func resolve<T>(registrationName: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: registrationName) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
}
