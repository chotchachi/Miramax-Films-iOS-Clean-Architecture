//
//  NetworkAssembly.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/09/2022.
//

import Swinject
import Domain
import Data

final class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(Api.self) { _ in
            return NetworkManager(
                genreNetworking: .getNetworking(),
                movieNetworking: .getNetworking(),
                tvShowNetworking: .getNetworking(),
                searchNetworking: .getNetworking(),
                peopleNetworking: .getNetworking()
            )
        }
    }
}
