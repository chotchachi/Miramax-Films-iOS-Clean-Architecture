//
//  Genre.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/09/2022.
//

struct Genre {
    let id: Int
    let name: String
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
