//
//  NetworkConfiguration.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import Foundation

final class NetworkConfiguration {
    static let shared = NetworkConfiguration()

    private(set) var apiKey = ""

    var baseAPIURL: URL {
        let urlString = "https://api.themoviedb.org/3"
        guard let url = URL(string: urlString) else { fatalError("Base URL Invalid") }
        return url
    }

    private init() {}

    func configure(with apiKey: String) {
        self.apiKey = apiKey
    }

}
