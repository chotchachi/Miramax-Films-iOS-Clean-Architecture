//
//  NetworkConfigurationProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Foundation

protocol NetworkConfigurationProtocol {
    var baseAPIURL: URL { get }
    var apiKey: String { get }
}
