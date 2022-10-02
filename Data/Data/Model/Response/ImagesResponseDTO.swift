//
//  ImagesResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper
import Domain

public struct ImagesResponseDTO: Mappable {
    public var profiles: [ImageDTO] = []
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        profiles <- map["profiles"]
    }
}
