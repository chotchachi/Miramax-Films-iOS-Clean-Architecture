//
//  AppDIContainer.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    let container = Container()
    let assembler: Assembler
    
    init() {
        assembler = Assembler(
            [
                NetworkAssembly(),
                RepositoryAssembly(),
                ViewModelAssembly()
            ],
            container: container
        )
    }
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T>(registrationName: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: registrationName) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
}
