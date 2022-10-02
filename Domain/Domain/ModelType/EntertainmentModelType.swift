//
//  EntertainmentModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

public enum EntertainmentType {
    case movie
    case tvShow
}

public protocol EntertainmentModelType {
    var entertainmentModelType: EntertainmentType { get }
    var entertainmentModelId: Int { get }
    var entertainmentModelName: String { get }
    var entertainmentModelOverview: String { get }
    var entertainmentModelPosterURL: URL? { get }
    var entertainmentModelBackdropURL: URL? { get }
}
