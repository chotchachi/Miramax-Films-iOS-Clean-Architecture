//
//  iCarouselDelegate.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit

public protocol iCarouselDelegate: AnyObject {
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel)
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel)
    func carouselDidScroll(_ carousel: iCarousel)
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel)
    func carouselWillBeginDragging(_ carousel: iCarousel)
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool)
    func carouselWillBeginDecelerating(_ carousel: iCarousel)
    func carouselDidEndDecelerating(_ carousel: iCarousel)

    func carousel(_ carousel: iCarousel, shouldSelectItemAt index: Int) -> Bool
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int)

    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat
}
public extension iCarouselDelegate {
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {}
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {}
    func carouselDidScroll(_ carousel: iCarousel) {}
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {}
    func carouselWillBeginDragging(_ carousel: iCarousel) {}
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {}
    func carouselWillBeginDecelerating(_ carousel: iCarousel) {}
    func carouselDidEndDecelerating(_ carousel: iCarousel) {}

    func carousel(_ carousel: iCarousel, shouldSelectItemAt index: Int) -> Bool { true }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {}

    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat { 0 }
}
