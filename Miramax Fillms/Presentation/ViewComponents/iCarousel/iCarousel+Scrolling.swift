//
//  iCarousel+Util.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit
extension iCarousel {
    public var currentItemIndex: Int {
        get { clamped(index: Int(round(scrollOffset))) }
        set { scrollOffset = CGFloat(newValue) }
    }
    public func scrollBy(offset: CGFloat, duration: TimeInterval) {
        if duration > 0 {
            isDecelerating = false
            isScrolling = true
            state.startTime = CACurrentMediaTime()
            state.startOffset = scrollOffset
            state.scrollDuration = duration
            state.endOffset = state.startOffset + offset
            if !isWrapEnabled {
                state.endOffset = clamped(offset: state.endOffset)
            }
            delegate?.carouselWillBeginScrollingAnimation(self)
            startAnimation()
        } else {
            scrollOffset += offset
        }
    }
    public func scrollTo(offset: CGFloat, duration: TimeInterval) {
        scrollBy(offset: minScrollDistance(fromOffset: scrollOffset, toOffset: offset), duration: duration)
    }
    public func scrollByNumberOfItems(_ itemCount: Int, duration: TimeInterval) {
        if duration > 0 {
            var offset: CGFloat = 0
            if itemCount > 0 {
                offset = floor(scrollOffset) + CGFloat(itemCount) - scrollOffset
            } else if itemCount < 0 {
                offset = ceil(scrollOffset) + CGFloat(itemCount) - scrollOffset
            } else {
                offset = round(scrollOffset) - scrollOffset
            }
            scrollBy(offset: offset, duration: duration)
        } else {
            scrollOffset = CGFloat(clamped(index: state.previousItemIndex + itemCount))
        }
    }
    public func scrollToItem(at index: Int, duration: TimeInterval) {
        scrollTo(offset: CGFloat(index), duration: duration)
    }
    public func scrollToItem(at index: Int, animated: Bool) {
        scrollToItem(at: index, duration: animated ? iCarousel.global.scrollDuration : 0)
    }

}
extension iCarousel {
    public func removeItem(at index: Int, animated: Bool) {
        let index = clamped(index: index)
        guard let itemView = self.itemView(at: index) else {
            return
        }
        if animated {
            UIView.animate(withDuration: 0.1, animations: {
                self.queue(itemView: itemView)
                itemView.itemCell?.layer.opacity = 0.0
            }, completion: { _ in
                itemView.itemCell?.removeFromSuperview()
                UIView.animate(withDuration: iCarousel.global.insertDuration, delay: 0.1, animations: {
                    self.removeView(at: index)
                    self.numberOfItems -= 1
                    self.isWrapEnabled = self.animator.isWrapEnabled
                    self.updateNumberOfVisibleItems()
                    self._scrollOffset = CGFloat(self.currentItemIndex)
                    self.didScroll()
                }, completion: { _ in
                    self.depthSortViews()
                })
            })
        } else {
            transactionAnimated(false) {
                self.queue(itemView: itemView)
                itemView.itemCell?.removeFromSuperview()
                removeView(at: index)
                self.removeView(at: index)
                self.numberOfItems -= 1
                self.isWrapEnabled = self.animator.isWrapEnabled
                // updateNumberOfVisibleItems是否需要加
                self._scrollOffset = CGFloat(self.currentItemIndex)
                self.didScroll()
                self.depthSortViews()
            }
        }
    }
    public func insertItem(at index: Int, animated: Bool) {
        self.numberOfItems += 1
        self.isWrapEnabled = self.animator.isWrapEnabled
        self.updateNumberOfVisibleItems()
        let index = clamped(index: index)
        insert(nil, at: index)
        loadView(at: index)
        if abs(itemWidth) < iCarousel.global.floatErrorMargin {
            updateItemWidth()
        }
        if animated {
            UIView.animate(withDuration: iCarousel.global.insertDuration, animations: {
                self.transformItemViews()
            }, completion: { _ in
                self.didScroll()
            })
        } else {
            transactionAnimated(false) {
                didScroll()
            }
        }
        if scrollOffset < 0 {
            scrollToItem(at: 0, animated: animated && numberOfPlaceholders > 0)
        }
    }
    public func reloadItem(at index: Int, animated: Bool) {
        guard let containerView = self.itemView(at: index)?.itemCell else {
            return
        }
        if animated {
            let transition = CATransition()
            transition.duration = iCarousel.global.insertDuration
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.type = .fade
            containerView.layer.add(transition, forKey: nil)
        }
        loadView(at: index, withContainerView: containerView)
    }
}
// MARK: -
extension iCarousel {
    func clamped(offset: CGFloat) -> CGFloat {
        if numberOfItems <= 0 {
            return -1.0
        }
        let numberOfItems: CGFloat = CGFloat(self.numberOfItems)
        if isWrapEnabled {
            return offset - floor(offset / numberOfItems) * numberOfItems
        } else {
            return min(max(0, offset), max(0, numberOfItems - 1))
        }
    }
    func clamped(index: Int) -> Int {
        if numberOfItems <= 0 {
            return -1
        } else if isWrapEnabled {
            let numberOfItems: CGFloat = CGFloat(self.numberOfItems)
            let index: CGFloat = CGFloat(index)
            return Int(index - floor(index / numberOfItems) * numberOfItems)
        } else {
            return min(max(0, index), max(0, numberOfItems - 1))
        }
    }
}
extension iCarousel {
    func minScrollDistance<T>(from: T, to: T, numberOfItems: T) -> T where T: Comparable, T: SignedNumeric {
        let directDistance = to - from
        if isWrapEnabled {
            var wrappedDistance = min(to, from) + numberOfItems - max(to, from)
            if from < to {
                wrappedDistance = -wrappedDistance
            }
            return abs(directDistance) <= abs(wrappedDistance) ? directDistance : wrappedDistance
        }
        return directDistance
    }
    func minScrollDistance(fromOffset: CGFloat, toOffset: CGFloat) -> CGFloat {
        minScrollDistance(from: fromOffset, to: toOffset, numberOfItems: CGFloat(numberOfItems))
    }
    func minScrollDistance(fromIndex: Int, toIndex: Int) -> Int {
        minScrollDistance(from: fromIndex, to: toIndex, numberOfItems: numberOfItems)
    }
}
