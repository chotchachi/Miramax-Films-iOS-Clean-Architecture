//
//  Video.swift
//  Domain
//
//  Created by Thanh Quang on 15/10/2022.
//

import Foundation

public struct Video: Equatable {
    public let name: String
    public let key: String
    public let site: String
    
    public init(name: String, key: String, site: String) {
        self.name = name
        self.key = key
        self.site = site
    }
}
