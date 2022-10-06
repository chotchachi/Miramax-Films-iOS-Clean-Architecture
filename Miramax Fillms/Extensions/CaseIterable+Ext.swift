//
//  CaseIterable+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

import Foundation

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
