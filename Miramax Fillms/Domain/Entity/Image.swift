//
//  Image.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

struct Image: Equatable {
    let filePath: String
    let width: Int
    let height: Int
    let aspectRatio: Double
}

extension Image: ImageConfigurable {
    var fileURL: URL? {
        let urlString = regularImageBaseURLString.appending(filePath)
        return URL(string: urlString)
    }
}
