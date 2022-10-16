//
//  VideoDTO.swift
//  Data
//
//  Created by Thanh Quang on 15/10/2022.
//

import ObjectMapper
import Domain

public struct VideoDTO : Mappable {
    public var name: String = ""
    public var key: String = ""
    public var site: String = ""
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        key <- map["key"]
        site <- map["site"]
    }
}

extension VideoDTO: DomainConvertibleType {
    public func asDomain() -> Video {
        return Video(name: name, key: key, site: site)
    }
}
