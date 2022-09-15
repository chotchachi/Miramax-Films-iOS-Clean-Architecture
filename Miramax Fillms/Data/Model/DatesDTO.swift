//
//  DatesDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import ObjectMapper

struct DatesDTO : Mappable {
    var maximum: String!
    var minimum: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        maximum <- map["maximum"]
        minimum <- map["minimum"]
    }
}

extension DatesDTO: DomainConvertibleType {
    func asDomain() -> Dates {
        return Dates(maximum: maximum, minimum: minimum)
    }
}
