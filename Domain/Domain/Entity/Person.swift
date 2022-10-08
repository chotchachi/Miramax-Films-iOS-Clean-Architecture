//
//  Person.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public struct Person: PersonModelType {
    public let id: Int
    public let name: String
    public let profilePath: String?
    
    public init(id: Int, name: String, profilePath: String?) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
    }
}
