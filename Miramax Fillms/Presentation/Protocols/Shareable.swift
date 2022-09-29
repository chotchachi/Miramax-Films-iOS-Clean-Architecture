//
//  Shareable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import UIKit

protocol Shareable: AnyObject {
    var btnShare: ShareButton { get }
    func disableShare()
    func enableShare()
}

extension Shareable {
    func disableShare() {
        btnShare.isEnabled = false
        btnShare.alpha = 0.5
    }
    
    func enableShare() {
        btnShare.isEnabled = true
        btnShare.alpha = 1.0
    }
}
