//
//  iCarousel+Animation.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit

extension iCarousel {
    func startAnimation() {
        if self.timer == nil {
            let timer = Timer(timeInterval: 1.0/60.0, repeats: true) { [weak self] (_) in
                guard let self = self else { return }
                self.transactionAnimated(false) {
                    self.step()
                }
            }
            self.timer = timer
            RunLoop.main.add(timer, forMode: .default)
            RunLoop.main.add(timer, forMode: .tracking)
        }
    }

    func stopAnimation() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
extension iCarousel {
    func decelerationDistance() -> CGFloat {
        let decelerationMultiplier = iCarousel.global.decelerationMultiplier
        let acceleration = -state.startVelocity * decelerationMultiplier * (1.0 - decelerationRate)
        return -pow(state.startVelocity, 2.0) / (2.0 * acceleration)
    }
    func shouldDecelerate() -> Bool {
        let scrollSpeedThreshold = iCarousel.global.scrollSpeedThreshold
        let decelerateThreshold = iCarousel.global.decelerateThreshold
        return (abs(state.startVelocity) > scrollSpeedThreshold) &&
        (abs(decelerationDistance()) > decelerateThreshold)
    }
    func shouldScroll() -> Bool {
        let scrollSpeedThreshold = iCarousel.global.scrollSpeedThreshold
        let scrollDistanceThreshold = iCarousel.global.scrollDistanceThreshold
        return (abs(state.startVelocity) > scrollSpeedThreshold) &&
            (abs(scrollOffset - CGFloat(self.currentItemIndex)) > scrollDistanceThreshold)
    }

    func startDecelerating() {
        var distance = decelerationDistance()
        state.startOffset = scrollOffset
        state.endOffset = state.startOffset + distance
        if isPagingEnabled {
            if distance > 0.0 {
                state.endOffset = ceil(state.startOffset)
            } else {
                state.endOffset = floor(state.startOffset)
            }
        } else if stopAtItemBoundary {
            if distance > 0.0 {
                state.endOffset = ceil(state.endOffset)
            } else {
                state.endOffset = floor(state.endOffset)
            }
        }
        if !isWrapEnabled {
            if bounces {
                state.endOffset = max(-bounceDistance, min(CGFloat(numberOfItems) - 1.0 + bounceDistance, state.endOffset))
            } else {
                state.endOffset = clamped(offset: state.endOffset)
            }
        }
        distance = state.endOffset - state.startOffset

        state.startTime = CACurrentMediaTime()
        state.scrollDuration = TimeInterval(abs(distance) / abs(0.5 * state.startVelocity))

        if distance != 0.0 {
            isDecelerating = true
            startAnimation()
        }
    }

    func easeInOut(time: CGFloat) -> CGFloat {
        return (time < 0.5) ? 0.5 * pow(time * 2.0, 3.0) : 0.5 * pow(time * 2.0 - 2.0, 3.0) + 1.0
    }
}
extension iCarousel {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    @objc private func step() {
        let currentTime = CACurrentMediaTime()
        var delta = CGFloat(currentTime - state.lastTime)
        state.lastTime = currentTime

        let floatErrorMargin = iCarousel.global.floatErrorMargin
        if isScrolling && !isDragging {
            let time = CGFloat(min(1.0, (currentTime - state.startTime) / state.scrollDuration))
            delta = easeInOut(time: time)
            _scrollOffset = state.startOffset + (state.endOffset - state.startOffset) * CGFloat(delta)
            didScroll()
            if time >= 1.0 {
                isScrolling = false
                depthSortViews()
                transactionAnimated(true) {
                    delegate?.carouselDidEndScrollingAnimation(self)
                }
            }
        } else if isDecelerating {
            let scrollDuration = CGFloat(state.scrollDuration)
            let time = min(scrollDuration, CGFloat(currentTime - state.startTime))
            let acceleration = -state.startVelocity / scrollDuration
            let distance = state.startVelocity * time + 0.5 * acceleration * pow(time, 2.0)
            _scrollOffset = state.startOffset + distance
            didScroll()
            if abs(time - scrollDuration) < floatErrorMargin {
                isDecelerating = false
                transactionAnimated(true) {
                    delegate?.carouselDidEndDecelerating(self)
                }

                if (scrollToItemBoundary || abs(scrollOffset - clamped(offset: scrollOffset)) > floatErrorMargin) && !canAutoscroll {
                    if abs(scrollOffset - CGFloat(self.currentItemIndex)) < floatErrorMargin {
                        // call scroll to trigger events for legacy support reasons
                        // even though technically we don't need to scroll at all
                        scrollToItem(at: self.currentItemIndex, duration: 0.01)
                    } else {
                        scrollToItem(at: self.currentItemIndex, animated: true)
                    }
                } else {
                    var difference = round(scrollOffset) - scrollOffset
                    if difference > 0.5 {
                        difference -= 1.0
                    } else if difference < -0.5 {
                        difference += 1.0
                    }
                    let maxToggleDuration = iCarousel.global.maxToggleDuration
                    state.toggleTime = TimeInterval(CGFloat(currentTime) - maxToggleDuration * abs(difference))
                    toggle = max(-1.0, min(1.0, -difference))
                }
            }
        } else if canAutoscroll && !isDragging {
            // autoscroll goes backwards from what you'd expect, for historical reasons
            if self.isPagingEnabled {
                state.tempOnePageValue += delta * autoscroll
                if abs(state.tempOnePageValue) >= 1 {
                    let tempScrollOffset = clamped(offset: scrollOffset - max(-1, min(1, state.tempOnePageValue)))
                    state.tempOnePageValue = 0
                    scrollToItem(at: Int(tempScrollOffset), animated: true)
                }
            } else {
                if state.tempOnePageValue != 0 {
                    // isPagingEnabled更改时 有可能导致存储的旧值，需要清零
                    state.tempOnePageValue = 0
                }
                self.scrollOffset = clamped(offset: scrollOffset - delta * autoscroll)
            }
        } else if abs(toggle) > floatErrorMargin {
            var toggleDuration = state.startVelocity > 0 ? min(1.0, max(0.0, 1.0 / abs(state.startVelocity))): 1.0
            let minToggleDuration = iCarousel.global.minToggleDuration
            let maxToggleDuration = iCarousel.global.maxToggleDuration
            toggleDuration = minToggleDuration + (maxToggleDuration - minToggleDuration) * toggleDuration
            let time = min(1.0, CGFloat(currentTime - state.toggleTime) / toggleDuration)
            delta = easeInOut(time: time)
            toggle = toggle < 0.0 ? (delta - 1.0) : (1.0 - delta)
            didScroll()
        } else if !canAutoscroll {
            stopAnimation()
        }
    }
    func didScroll() {
        if isWrapEnabled || !bounces {
            _scrollOffset = clamped(offset: scrollOffset)
        } else {
            let minV = -bounceDistance
            let maxV = max(CGFloat(numberOfItems) - 1, 0.0) + bounceDistance
            if scrollOffset < minV {
                _scrollOffset = minV
                state.startVelocity = 0.0
            } else if scrollOffset > maxV {
                _scrollOffset = maxV
                state.startVelocity = 0.0
            }
        }

        // check if index has changed
        let difference = minScrollDistance(fromIndex: self.currentItemIndex, toIndex: state.previousItemIndex)
        if difference != 0 {
            state.toggleTime = CACurrentMediaTime()
            toggle = CGFloat(max(-1, min(1, difference)))
            startAnimation()
        }
        loadUnloadViews()
        transformItemViews()
        let floatErrorMargin = iCarousel.global.floatErrorMargin
        // notify delegate of offset change
        if abs(scrollOffset - state.previousScrollOffset) > floatErrorMargin {
            transactionAnimated(true) {
                delegate?.carouselDidScroll(self)
            }
        }

        // notify delegate of index change
        if state.previousItemIndex != self.currentItemIndex {
            transactionAnimated(true) {
                delegate?.carouselCurrentItemIndexDidChange(self)
            }
        }

        // update previous index
        state.previousScrollOffset = _scrollOffset
        state.previousItemIndex = self.currentItemIndex
    }
}
extension iCarousel {
    @discardableResult
    func transactionAnimated<T>(_ enabled: Bool, _ closure: () -> T) -> T {
        CATransaction.begin()
        CATransaction.setDisableActions(!enabled)
        let result = closure()
        CATransaction.commit()
        return result
    }
}
