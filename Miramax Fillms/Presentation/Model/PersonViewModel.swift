//
//  PersonViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 10/10/2022.
//

import Foundation
import Domain

struct PersonViewModel {
    let id: Int
    let name: String
    let biography: String?
    let profileURL: URL?
    let birthday: String?
    let isBookmark: Bool
}

extension Person: PresentationConvertibleType {
    func asPresentation() -> PersonViewModel {
        return PersonViewModel(
            id: id,
            name: name,
            biography: biography,
            profileURL: profileURL,
            birthday: birthday,
            isBookmark: isBookmark
        )
    }
}

extension Cast: PresentationConvertibleType {
    func asPresentation() -> PersonViewModel {
        return PersonViewModel(
            id: id,
            name: name,
            biography: nil,
            profileURL: profileURL,
            birthday: nil,
            isBookmark: false
        )
    }
}

extension Crew: PresentationConvertibleType {
    func asPresentation() -> PersonViewModel {
        return PersonViewModel(
            id: id,
            name: name,
            biography: nil,
            profileURL: profileURL,
            birthday: nil,
            isBookmark: false
        )
    }
}

extension BookmarkPerson: PresentationConvertibleType {
    func asPresentation() -> PersonViewModel {
        return PersonViewModel(
            id: id,
            name: name,
            biography: biography,
            profileURL: profileURL,
            birthday: birthday,
            isBookmark: true
        )
    }
}
