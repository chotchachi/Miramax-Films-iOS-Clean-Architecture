//
//  iCarousel+Gesture.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit
extension iCarousel {
    func setupGesture() {
        let pan: UIPanGestureRecognizer = .init(target: self, action: #selector(didPan))
        pan.delegate = self
        contentView.addGestureRecognizer(pan)
        let tap: UITapGestureRecognizer = .init(target: self, action: #selector(didTap))
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
    }
}
extension iCarousel {
    @objc func didTap(_ tap: UITapGestureRecognizer) {
        // check for tapped view
        if let itemView = self.itemView(at: tap.location(in: contentView)),
            let index = self.index(of: itemView) {
            if delegate == nil || delegate!.carousel(self, shouldSelectItemAt: index) {
                if (index != self.currentItemIndex && centerItemWhenSelected) ||
                    (index == self.currentItemIndex && scrollToItemBoundary) {
                    scrollToItem(at: index, animated: true)
                }
                delegate?.carousel(self, didSelectItemAt: index)
            } else if isScrollEnabled && scrollToItemBoundary && canAutoscroll {
                scrollToItem(at: self.currentItemIndex, animated: true)
            }
        } else {
            scrollToItem(at: self.currentItemIndex, animated: true)
        }
    }
}
extension iCarousel {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        guard isScrollEnabled && numberOfItems > 0 else { return }
        switch pan.state {
        case .began:
            isDragging = true
            isScrolling = false
            isDecelerating = false
            let translation = pan.translation(in: self)
            state.previousTranslation = isVertical ? translation.y: translation.x
            delegate?.carouselWillBeginDragging(self)
        case .ended, .cancelled, .failed:
            isDragging = false
            state.didDrag = true
            if shouldDecelerate() {
                state.didDrag = false
                startDecelerating()
            }
            transactionAnimated(true) {
                delegate?.carouselDidEndDragging(self, willDecelerate: isDecelerating)
            }
            // 不需要减速 可以往下走
            guard !isDecelerating else {
                transactionAnimated(true) {
                    delegate?.carouselWillBeginDecelerating(self)
                }
                break
            }
            // isPagingEnabled优先级比 scrollToItemBoundary高
            if isPagingEnabled {
                scrollToItem(at: self.currentItemIndex, animated: true)
                break
            }
            let floatErrorMargin = iCarousel.global.floatErrorMargin
            // 滚动到Item边界
            guard (scrollToItemBoundary || abs(scrollOffset - clamped(offset: scrollOffset)) > floatErrorMargin) && !canAutoscroll else {
                depthSortViews()
                break
            }
            if abs(scrollOffset - CGFloat(self.currentItemIndex)) < floatErrorMargin {
                // call scroll to trigger events for legacy support reasons
                // even though technically we don't need to scroll at all
                scrollToItem(at: self.currentItemIndex, duration: 0.01)
            } else if shouldScroll() { // 是否需要滚动
                let direction = Int(state.startVelocity / abs(state.startVelocity))
                scrollToItem(at: self.currentItemIndex + direction, animated: true)
            } else {
                scrollToItem(at: self.currentItemIndex, animated: true)
            }
        case .changed:
            let _translation = pan.translation(in: self)
            let _velocity = pan.velocity(in: self)
            let translation = isVertical ? _translation.y: _translation.x
            let velocity = isVertical ? _velocity.y: _velocity.x

            var factor: CGFloat = 1.0
            if !isWrapEnabled && bounces {
                factor = 1.0 - min(abs(scrollOffset - clamped(offset: scrollOffset)), bounceDistance) / bounceDistance
            }

            state.startVelocity = -velocity * factor * scrollSpeed / itemWidth
            _scrollOffset -= (translation - state.previousTranslation) * factor * offsetMultiplier / itemWidth
            state.previousTranslation = translation
            didScroll()
        case .possible: break
        default: break
        }
    }
}
extension iCarousel: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if isScrollEnabled {
            isDragging = false
            isScrolling = false
            isDecelerating = false
        }
        switch gestureRecognizer {
        case _ as UITapGestureRecognizer:
            var index = viewOrSuperviewIndex(touch.view)
            if index == nil, centerItemWhenSelected {
                // view is a container view
                index = viewOrSuperviewIndex(touch.view?.subviews.last)
            }
            if index != nil {
                if viewOrSuperview(touch.view, implementsSelector: #selector(touchesBegan(_:with:))) {
                    return false
                }
            }
        case _ as UIPanGestureRecognizer:
            if !isScrollEnabled {
                return false
            } else if viewOrSuperview(touch.view, implementsSelector: #selector(touchesMoved(_:with:))) {
                if let scrollView = viewOrSuperview(touch.view, UIScrollView.self) {
                    return !scrollView.isScrollEnabled ||
                    (self.isVertical && scrollView.contentSize.height <= scrollView.frame.size.height) ||
                    (!self.isVertical && scrollView.contentSize.width <= scrollView.frame.size.width)
                }
                if viewOrSuperview(touch.view, UIControl.self) != nil {
                    return true
                }
                return false
            }
        default: break
        }
        return true
    }
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer {
        case let pan as UIPanGestureRecognizer:
            // ignore vertical swipes
            let translation = pan.translation(in: self)
            if ignorePerpendicularSwipes {
                if self.isVertical {
                    return abs(translation.x) <= abs(translation.y)
                } else {
                    return abs(translation.x) >= abs(translation.y)
                }
            }
        default: break
        }
        return true
    }
}
extension iCarousel {
    func viewOrSuperviewIndex(_ view: UIView?) -> Int? {
        guard let view = view else {
            return nil
        }
        if view == contentView {
            return nil
        }
        if let index = index(of: view) {
            return index
        }
        if let view = view.superview {
            return viewOrSuperviewIndex(view)
        }
        return nil
    }
    func viewOrSuperview(_ view: UIView?, implementsSelector selector: Selector) -> Bool {
        guard let view = view, view != contentView else {
            return false
        }
        // thanks to @mattjgalloway and @shaps for idea
        // https://gist.github.com/mattjgalloway/6279363
        // https://gist.github.com/shaps80/6279008
        var _viewClass: AnyClass? = type(of: view)
        while let viewClass = _viewClass, viewClass != UIView.self {
            var numberOfMethods: UInt32 = 0
            let methods = class_copyMethodList(viewClass, &numberOfMethods)
            if let methods = methods {
                defer {
                    free(methods)
                }
                for i in 0..<numberOfMethods {
                    if method_getName(methods[Int(i)]) == selector {
                        return true
                    }
                }
                _viewClass = viewClass.superclass()
            }

        }
        if let superView = view.superview {
            return viewOrSuperview(superView, implementsSelector: selector)
        }
        return false
    }
    func viewOrSuperview<T: UIView>(_ view: UIView?, _ type: T.Type) -> T? {
        guard let view = view, view != contentView else {
            return nil
        }
        if let result = view as? T {
            return result
        }
        if let superView = view.superview {
            return viewOrSuperview(superView, type)
        }
        return nil
    }
}
