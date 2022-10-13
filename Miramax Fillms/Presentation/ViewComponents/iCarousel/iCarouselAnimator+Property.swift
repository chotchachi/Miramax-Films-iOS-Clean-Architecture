//
//  iCarouselAnimator+Property.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/23.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit

public extension iCarousel.Animator {
    func wrapEnabled(_ wrapEnabled: Bool) -> Self {
        self.isWrapEnabled = wrapEnabled
        return self
    }
    func offsetMultiplier(_ offsetMultiplier: CGFloat) -> Self {
        self.offsetMultiplier = offsetMultiplier
        return self
    }
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
