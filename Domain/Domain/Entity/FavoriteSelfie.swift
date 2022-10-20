//
//  FavoriteSelfie.swift
//  Domain
//
//  Created by Thanh Quang on 19/10/2022.
//

import Foundation

public struct FavoriteSelfie {
    public let id: String
    public let name: String
    public let frame: String?
    public let userLocation: String?
    public let userCreateDate: Date?
    public let createAt: Date
    
    public init(id: String = "", name: String, frame: String?, userLocation: String?, userCreateDate: Date?, createAt: Date) {
        self.id = id
        self.name = name
        self.frame = frame
        self.userLocation = userLocation
        self.userCreateDate = userCreateDate
        self.createAt = createAt
    }
}
