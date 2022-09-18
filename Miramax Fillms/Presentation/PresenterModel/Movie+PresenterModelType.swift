//
//  Movie+PresenterModelType.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

extension Movie: PresenterModelType {
    var thumbImageURL: URL? {
        return posterURL
    }
}
