//
//  SelfieFrame.swift
//  Domain
//
//  Created by Thanh Quang on 15/10/2022.
//

import Foundation

public struct SelfieFrame {
    public let name: String
    public let previewURL: URL
    
    public init(name: String, previewURL: URL) {
        self.name = name
        self.previewURL = previewURL
    }
}
