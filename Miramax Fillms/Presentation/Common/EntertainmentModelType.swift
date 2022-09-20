//
//  EntertainmentModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

protocol EntertainmentModelType {
    var thumbImageURL: URL? { get }
    var backdropImageURL: URL? { get }
    var textName: String { get }
    var textDescription: String { get }
}
