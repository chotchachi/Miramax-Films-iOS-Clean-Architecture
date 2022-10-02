//
//  NetworkConfigurable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Foundation

protocol NetworkConfigurable {
    var baseApiURL: URL { get }
    var apiKey: String { get }
}

extension NetworkConfigurable {
    private var networkConfiguration: NetworkConfigurationProtocol {
        return NetworkConfiguration.shared
    }
    
    var baseApiURL: URL {
        return networkConfiguration.baseAPIURL
    }
    
    var apiKey: String {
        return networkConfiguration.apiKey
    }
}
