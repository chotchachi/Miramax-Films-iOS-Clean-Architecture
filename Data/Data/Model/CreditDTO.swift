//
//  CreditDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 19/09/2022.
//

import ObjectMapper
import Domain

public struct CreditDTO : Mappable {
    public var cast: [CastDTO] = []
    public var crew: [CrewDTO] = []
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        cast <- map["cast"]
        crew <- map["crew"]
    }
}

extension CreditDTO: DomainConvertibleType {
    public func asDomain() -> Credit {
        return Credit(
            cast: cast.map { $0.asDomain() },
            crew: crew.map { $0.asDomain() }
        )
    }
}
