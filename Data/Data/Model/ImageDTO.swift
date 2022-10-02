//
//  ImageDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper
import Domain

public struct ImageDTO : Mappable {
    public var filePath: String = ""
    public var width: Int = 0
    public var height: Int = 0
    public var aspectRatio: Double = 0.0
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        filePath <- map["file_path"]
        width <- map["width"]
        height <- map["height"]
        aspectRatio <- map["aspect_ratio"]
    }
}

extension ImageDTO: DomainConvertibleType {
    public func asDomain() -> Image {
        return Image(
            filePath: filePath,
            width: width,
            height: height,
            aspectRatio: aspectRatio
        )
    }
}
