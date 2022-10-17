//
//  SelfieFrameDTO.swift
//  Data
//
//  Created by Thanh Quang on 15/10/2022.
//

import ObjectMapper
import Domain

public struct SelfieFrameDTO : Mappable {
    public var name: String!
    public var path: String!
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        path <- map["path"]
    }
}

extension SelfieFrameDTO {
    private var destinationURL: URL {
        return ResourceManager.selfieFramesBundleURL
            .appendingPathComponent(path, isDirectory: true)
    }
    
    private var previewURL: URL {
        return destinationURL
            .appendingPathComponent("preview")
            .appendingPathExtension("png")
    }
    
    private var frameURL: URL {
        return destinationURL
            .appendingPathComponent("frame")
            .appendingPathExtension("png")
    }
}

extension SelfieFrameDTO: DomainConvertibleType {
    public func asDomain() -> SelfieFrame {
        return SelfieFrame(name: name, previewURL: previewURL, frameURL: frameURL)
    }
}
