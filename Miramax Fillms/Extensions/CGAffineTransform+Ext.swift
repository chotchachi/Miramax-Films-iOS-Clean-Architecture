//
//  CGAffineTransform+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit

extension CGAffineTransform {

    mutating func rotate(by rotationAngle: CGFloat) {
        self = self.rotated(by: rotationAngle)
    }

    mutating func scale(by scalingFactor: CGFloat) {
        self = self.scaledBy(x: scalingFactor, y: scalingFactor)
    }

}
