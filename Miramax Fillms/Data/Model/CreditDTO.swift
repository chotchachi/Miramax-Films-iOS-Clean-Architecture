//
//  CreditDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper

struct CreditDTO : Mappable {
    var cast: [CastDTO] = []
    var crew: [CrewDTO] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        cast <- map["cast"]
        crew <- map["crew"]
    }
}

extension CreditDTO: DomainConvertibleType {
    func asDomain() -> Credit {
        return Credit(
            cast: cast.map { $0.asDomain() },
            crew: crew.map { $0.asDomain() }
        )
    }
}
