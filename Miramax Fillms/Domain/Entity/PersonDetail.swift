//
//  PersonDetail.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

struct PersonDetail: Equatable {
    let id: Int
    let name: String
    let birthday: String?
    let biography: String
    let profilePath: String?
    let images: [Image]
    let castCredits: [PersonCredit]
    let crewCredits: [PersonCredit]
}

extension PersonDetail: ImageConfigurable {
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        let urlString = regularImageBaseURLString.appending(profilePath)
        return URL(string: urlString)
    }
}

extension PersonDetail {
    var entertainmentItems: [EntertainmentModelType] {
        return castCredits + crewCredits
    }
    
    var departments: [String] {
        var allJobs: [String] = []
        allJobs.append(contentsOf: crewCredits.compactMap { $0.job })
        if !castCredits.isEmpty {
            allJobs.append("Actor")
        }
        return Array(Set(allJobs))
    }
}
