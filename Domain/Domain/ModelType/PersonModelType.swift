//
//  PersonModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation

public protocol PersonModelType {
    var personModelId: Int { get }
    var personModelProfileURL: URL? { get }
    var personModelName: String? { get }
}
