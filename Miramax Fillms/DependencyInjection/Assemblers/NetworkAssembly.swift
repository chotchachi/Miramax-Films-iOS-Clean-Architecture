//
//  NetworkAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

import Swinject

final class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(Api.self) { resolver in
            return NetworkManager(appNetworking: AppNetworking.getNetworking())
        }
    }
}
