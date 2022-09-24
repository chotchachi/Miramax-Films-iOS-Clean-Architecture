//
//  PersonCredit.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

struct PersonCredit: Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    let character: String?
    let job: String?
}

extension PersonCredit: ImageConfigurable {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        let urlString = regularImageBaseURLString.appending(posterPath)
        return URL(string: urlString)
    }
}

extension PersonCredit: EntertainmentModelType {
    var entertainmentModelId: Int {
        return id
    }
    
    var thumbImageURL: URL? {
        return posterURL
    }
    
    var backdropImageURL: URL? {
        return nil
    }
    
    var textName: String {
        return title
    }
    
    var textDescription: String {
        return ""
    }
}
