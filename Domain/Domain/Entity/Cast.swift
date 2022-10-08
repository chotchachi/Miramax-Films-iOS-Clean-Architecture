//
//  Cast.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Cast: PersonModelType {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let character: String

    public init(id: Int, name: String, profilePath: String?, character: String) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.character = character
    }
}
