//
//  Crew.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Crew: PersonModelType {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let job: String

    public init(id: Int, name: String, profilePath: String?, job: String) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.job = job
    }
}
