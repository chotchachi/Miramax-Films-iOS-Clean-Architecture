//
//  NetworkConfiguration.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Foundation

final class NetworkConfiguration: NetworkConfigurationProtocol {
    static let shared = NetworkConfiguration()
    
    var baseAPIURL: URL {
        let urlString = "https://api.themoviedb.org/3"
        guard let url = URL(string: urlString) else { fatalError("Base URL Invalid") }
        return url
    }
    
    var apiKey = ""

    func configure(with apiKey: String) {
        self.apiKey = apiKey
    }
}
