//
//  String+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
