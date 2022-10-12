//
//  Collection+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/10/2022.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
