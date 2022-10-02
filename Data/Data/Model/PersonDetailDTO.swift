//
//  PersonDetailDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper
import Domain

public struct PersonDetailDTO : Mappable {
    public var id: Int = 0
    public var name: String = ""
    public var birthday: String?
    public var biography: String = ""
    public var profilePath: String?
    public var images: [ImageDTO] = []
    public var castCredits: [PersonCreditDTO] = []
    public var crewCredits: [PersonCreditDTO] = []

    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        birthday <- map["birthday"]
        biography <- map["biography"]
        profilePath <- map["profile_path"]
        images <- map["images.profiles"]
        castCredits <- map["combined_credits.cast"]
        crewCredits <- map["combined_credits.crew"]
    }
}

extension PersonDetailDTO: DomainConvertibleType {
    public func asDomain() -> PersonDetail {
        return PersonDetail(
            id: id,
            name: name,
            birthday: birthday,
            biography: biography,
            profilePath: profilePath,
            images: images.map { $0.asDomain() },
//            castCredits: castCredits.map { $0.asDomain() },
//            crewCredits: crewCredits.map { $0.asDomain() }
            departments: getDepartments()
        )
    }
    
    private func getDepartments() -> [String] {
        var allJobs: [String] = []
        allJobs.append(contentsOf: crewCredits.compactMap { $0.job })
        if !castCredits.isEmpty {
            allJobs.append("Actor")
        }
        return Array(Set(allJobs))
    }
}
