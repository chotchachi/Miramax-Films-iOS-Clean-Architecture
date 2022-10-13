//
//  iCarouselAnimator.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit

extension iCarousel {
    open class Animator {
        open internal(set) var fadeMin: CGFloat = -.infinity
        open internal(set) var fadeMax: CGFloat = .infinity
        open internal(set) var fadeRange: CGFloat = 1.0
        open internal(set) var fadeMinAlpha: CGFloat = 0.0
        open internal(set) var spacing: CGFloat = 1.0
        open internal(set) var arc: CGFloat = .pi * 2.0
        open internal(set) var isWrapEnabled: Bool = false
        open internal(set) var offsetMultiplier: CGFloat = 1.0
        
        public init() {
            configInit()
        }
        
        open func configInit() {
            
        }
        
        open func alphaForItem(with offset: CGFloat) -> CGFloat {
            let factor: CGFloat
            if offset > fadeMax {
                factor = offset - fadeMax
            } else if offset < fadeMin {
                factor = fadeMin - offset
            } else {
                factor = 0
            }
            return 1.0 - min(factor, fadeRange) / fadeRange * (1.0 - fadeMinAlpha)
        }

        open func transformForItemView(with offset: CGFloat, in carousel: iCarousel) -> CATransform3D {
            var transform: CATransform3D = CATransform3DIdentity
            transform.m34 = carousel.perspective
            transform = CATransform3DTranslate(transform, -carousel.viewpointOffset.width, -carousel.viewpointOffset.height, 0.0)
            return transform
        }
        
        open func showBackfaces(view: UIView, in carousel: iCarousel) -> Bool {
            true
        }
        
        open func circularCarouselItemCount(in carousel: iCarousel) -> Int {
            _count1(in: carousel)
        }
        
        final func _numberOfVisibleItems(in carousel: iCarousel) -> Int {
            max(0, min(numberOfVisibleItems(in: carousel), _count1(in: carousel)))
        }
        
        open func numberOfVisibleItems(in carousel: iCarousel) -> Int {
            iCarousel.global.maxVisibleItems
        }
    }
    
    open class CanBeInvertedAnimator: Animator {
        public let inverted: Bool
        public init(inverted: Bool = false) {
            self.inverted = inverted
            super.init()
        }
    }
}

extension iCarousel.Animator {
    public func itemWidthWithSpacing(in carousel: iCarousel) -> CGFloat {
        carousel.itemWidth * spacing
    }
    public func _count1(in carousel: iCarousel) -> Int {
        carousel.numberOfItems + carousel.state.numberOfPlaceholdersToShow
    }
    public func _count2(in carousel: iCarousel) -> Int {
        let width = carousel.relativeWidth
        var count = Int(ceil(width / itemWidthWithSpacing(in: carousel)) * CGFloat.pi)
        count = min(iCarousel.global.maxVisibleItems, max(12, count))
        count = min(_count1(in: carousel), count)
        return count
    }
}

extension iCarousel.Animator {
    open class Rotary: iCarousel.CanBeInvertedAnimator {
        open override func configInit() {
            super.configInit()
            isWrapEnabled = true
        }
        
        open override func circularCarouselItemCount(in carousel: iCarousel) -> Int {
            _count2(in: carousel)
        }
        
        open override func transformForItemView(with offset: CGFloat, in carousel: iCarousel) -> CATransform3D {
            let transform = super.transformForItemView(with: offset, in: carousel)
            let count = CGFloat(circularCarouselItemCount(in: carousel))
            var radius = max(
                itemWidthWithSpacing(in: carousel) / 2,
                itemWidthWithSpacing(in: carousel) / 2 / tan(arc / 2.0 / count))
            var angle = offset * arc / count
            if inverted {
                radius = -radius
                angle = -angle
            }
            if carousel.isVertical {
                return CATransform3DTranslate(transform, 0.0, radius * sin(angle), radius * cos(angle) - radius)
            } else {
                return CATransform3DTranslate(transform, radius * sin(angle), 0.0, radius * cos(angle) - radius)
            }
        }
        
        open override func numberOfVisibleItems(in carousel: iCarousel) -> Int {
//            let numberOfVisibleItems: Int
//            if inverted {
//                numberOfVisibleItems = Int(circularCarouselItemCount(in: carousel) / 2)
//            } else {
//                numberOfVisibleItems = Int(circularCarouselItemCount(in: carousel))
//            }
//            return min(iCarousel.global.maxVisibleItems, numberOfVisibleItems)
            return 5
        }
    }
}
