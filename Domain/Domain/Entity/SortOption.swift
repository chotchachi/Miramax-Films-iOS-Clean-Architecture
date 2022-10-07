//
//  SortOption.swift
//  Domain
//
//  Created by Thanh Quang on 05/10/2022.
//

import Foundation

public struct SortOption: Equatable {
    public let text: String
    public let value: String
    
    public init(text: String, value: String) {
        self.text = text
        self.value = value
    }
}
