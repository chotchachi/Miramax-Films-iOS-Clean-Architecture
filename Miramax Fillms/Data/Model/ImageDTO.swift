//
//  ImageDTO.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 24/09/2022.
//

import ObjectMapper

struct ImageDTO : Mappable {
    var filePath: String = ""
    var width: Int = 0
    var height: Int = 0
    var aspectRatio: Double = 0.0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        filePath <- map["file_path"]
        width <- map["width"]
        height <- map["height"]
        aspectRatio <- map["aspect_ratio"]
    }
}

extension ImageDTO: DomainConvertibleType {
    func asDomain() -> Image {
        return Image(
            filePath: filePath,
            width: width,
            height: height,
            aspectRatio: aspectRatio
        )
    }
}
