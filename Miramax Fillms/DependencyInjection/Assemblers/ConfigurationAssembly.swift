//
//  ConfigurationAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Swinject

final class ConfigurationAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(NetworkConfigurationProtocol.self) { _ in
            return NetworkConfiguration(apiKey: "9f7ceb7615afe6f16274a953ad31c29e")
        }
    }
}
