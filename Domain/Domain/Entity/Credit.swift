//
//  Credit.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import Foundation

public struct Credit: Equatable {
    public let cast: [Cast]
    public let crew: [Crew]
    
    public init(cast: [Cast], crew: [Crew]) {
        self.cast = cast
        self.crew = crew
    }
}
