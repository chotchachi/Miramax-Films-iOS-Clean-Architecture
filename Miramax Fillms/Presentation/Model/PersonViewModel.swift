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
    let images: [Image]?
    let departments: [String]?
    let castMovies: [EntertainmentViewModel]?
    let castTVShows: [EntertainmentViewModel]?
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
            images: images,
            departments: departments,
            castMovies: castMovies.map { items in items.map { $0.asPresentation() } },
            castTVShows: castTVShows.map { items in items.map { $0.asPresentation() } },
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
            images: nil,
            departments: nil,
            castMovies: nil,
            castTVShows: nil,
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
            images: nil,
            departments: nil,
            castMovies: nil,
            castTVShows: nil,
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
            images: nil,
            departments: nil,
            castMovies: nil,
            castTVShows: nil,
            isBookmark: true
        )
    }
}
