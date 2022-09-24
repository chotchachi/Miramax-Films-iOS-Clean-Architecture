//
//  ImagesResponseDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper

struct ImagesResponseDTO: Mappable {
    var profiles: [ImageDTO] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        profiles <- map["profiles"]
    }
}
