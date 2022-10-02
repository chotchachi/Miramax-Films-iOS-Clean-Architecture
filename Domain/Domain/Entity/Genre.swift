//
//  Genre.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

public struct Genre: Equatable {
    public let id: Int
    public let name: String
    public var entertainmentType: EntertainmentType? = nil
    
    public init(id: Int, name: String, entertainmentType: EntertainmentType? = nil) {
        self.id = id
        self.name = name
        self.entertainmentType = entertainmentType
    }
}
