//
//  DesignableLabel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/10/2022.
//

import Foundation
import UIKit

@IBDesignable
class DesignableLabel: UILabel {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}
