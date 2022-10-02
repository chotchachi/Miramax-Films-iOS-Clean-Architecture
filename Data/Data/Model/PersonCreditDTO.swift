//
//  PersonCreditDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper
import Domain

public struct PersonCreditDTO : Mappable {
    public var id: Int = 0
    public var title: String = ""
    public var posterPath: String?
    public var character: String?
    public var job: String?
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        character <- map["character"]
        job <- map["job"]
    }
}
