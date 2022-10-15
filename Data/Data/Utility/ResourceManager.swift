//
//  ResourceManager.swift
//  Data
//
//  Created by Thanh Quang on 15/10/2022.
//

import Foundation

class ResourceManager {
    static var dataBundle: Bundle {
        guard let bundle = Bundle(identifier: "com.base.Data") else { fatalError("Cannot get bundle of Data layer") }
        return bundle
    }
    
    static var selfieFramesBundleURL: URL {
        return dataBundle.bundleURL.appendingPathComponent("SelfieFrames.bundle")
    }
}
