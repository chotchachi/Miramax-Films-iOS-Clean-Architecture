//
//  EntertainmentModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

protocol EntertainmentModelType {
    var entertainmentModelId: Int { get }
    var entertainmentModelName: String { get }
    var entertainmentModelOverview: String { get }
    var entertainmentModelPosterURL: URL? { get }
    var entertainmentModelBackdropURL: URL? { get }
}
