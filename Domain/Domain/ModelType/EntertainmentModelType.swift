//
//  EntertainmentModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public protocol EntertainmentModelType {
    var entertainmentModelType: EntertainmentType { get }
    var entertainmentModelId: Int { get }
    var entertainmentModelName: String { get }
    var entertainmentModelOverview: String { get }
    var entertainmentModelRating: Double { get }
    var entertainmentModelReleaseDate: String { get }
    var entertainmentModelBackdropURL: URL? { get }
    var entertainmentModelPosterURL: URL? { get }
    var entertainmentModelRuntime: Int? { get }
    var entertainmentModelDirectors: [Crew]? { get }
    var entertainmentModelWriters: [Crew]? { get }
    var entertainmentModelCasts: [Cast]? { get }
    var entertainmentModelSeasons: [Season]? { get }
    var entertainmentModelRecommends: [EntertainmentModelType]? { get }
    var entertainmentModelIsBookmark: Bool { get }
}
