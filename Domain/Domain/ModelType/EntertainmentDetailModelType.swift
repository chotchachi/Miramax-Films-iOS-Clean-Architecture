//
//  EntertainmentDetailModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation

public protocol EntertainmentDetailModelType {
    var entertainmentModelType: EntertainmentType { get }
    var entertainmentDetailTitle: String { get }
    var entertainmentPosterURL: URL? { get }
    var entertainmentVoteAverage: Double { get }
    var entertainmentRuntime: Int? { get }
    var entertainmentReleaseDate: String { get }
    var entertainmentOverview: String { get }
    var entertainmentDirectors: [Crew]? { get }
    var entertainmentWriters: [Crew]? { get }
    var entertainmentCasts: [Cast] { get }
    var entertainmentRecommends: [EntertainmentModelType] { get }
    var entertainmentSeasons: [Season]? { get }
}
