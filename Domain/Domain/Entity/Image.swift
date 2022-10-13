//
//  Image.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import Foundation

public struct Image: Equatable {
    public let filePath: String
    public let width: Int
    public let height: Int
    public let aspectRatio: Double
    
    public init(filePath: String, width: Int, height: Int, aspectRatio: Double) {
        self.filePath = filePath
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
    }
}

extension Image: ImageConfigurable {
    public var fileURL: URL? {
        let urlString = backdropImageBaseURLString.appending(filePath)
        return URL(string: urlString)
    }
}
