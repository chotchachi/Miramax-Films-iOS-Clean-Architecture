//
//  EntertainmentResponseModelType.swift
//  Domain
//
//  Created by Thanh Quang on 05/10/2022.
//

import Foundation

public protocol EntertainmentResponseModelType {
    var entertainmentResponsePage: Int { get }
    var entertainmentResponseResult: [EntertainmentModelType] { get }
    var entertainmentResponseTotalPages: Int { get }
    var entertainmentResponseTotalResults: Int { get }
}
