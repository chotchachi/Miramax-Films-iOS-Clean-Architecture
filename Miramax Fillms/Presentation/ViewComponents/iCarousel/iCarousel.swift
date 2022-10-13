//
//  iCarousel.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit

extension iCarousel {
    static let global: Global = Global()
    
    struct Global {
        let minToggleDuration: CGFloat = 0.2
        let maxToggleDuration: CGFloat = 0.4
        let scrollDuration: TimeInterval = 0.4
        let insertDuration: TimeInterval = 0.4
        let decelerateThreshold: CGFloat = 0.1
        let scrollSpeedThreshold: CGFloat = 2.0
        let scrollDistanceThreshold: CGFloat = 0.1
        let decelerationMultiplier: CGFloat = 300.0
        let floatErrorMargin: CGFloat = 0.000001
        let maxVisibleItems: Int = 10
    }
}

public class iCarousel: UIView {

    struct State {
        var startTime: TimeInterval = 0
        var lastTime: TimeInterval = 0
        var startOffset: CGFloat = .zero
        var endOffset: CGFloat = .zero
        var scrollDuration: TimeInterval = 0
        var previousItemIndex: Int = 0
        var previousScrollOffset: CGFloat = 0
        var numberOfPlaceholdersToShow: Int = 0
        var startVelocity: CGFloat = 0
        var toggleTime: TimeInterval = 0
        var previousTranslation: CGFloat = 0
        var didDrag: Bool = false
        var tempOnePageValue: CGFloat = 0
    }
    
    internal var state: State = State()
    internal var itemViewPool: Set<UIView> = []
    internal var placeholderViewPool: Set<UIView> = []

    internal var itemViews: [Int: UIView] = [:]
    internal var timer: Timer?

    public weak var dataSource: iCarouselDataSource? {
        didSet {
            if dataSource !== oldValue && dataSource != nil {
                reloadData()
            }
        }
    }
    
    public weak var delegate: iCarouselDelegate? {
        didSet {
            if delegate !== oldValue && delegate != nil && dataSource != nil {
                reloadData()
            }
        }
    }

    public var animator: iCarousel.Animator = .Rotary() {
        didSet {
            if animator !== oldValue {
                layOutItemViews()
            }
        }
    }
    public var perspective: CGFloat = -1.0/500.0 {
        didSet {
            transformItemViews()
        }
    }
    public var decelerationRate: CGFloat = 0.95
    public var scrollSpeed: CGFloat = 1.0
    public var bounceDistance: CGFloat = 1.0

    public var isScrollEnabled: Bool = true
    public var isPagingEnabled: Bool = false
    public var isVertical: Bool = false {
        didSet {
            if isVertical != oldValue {
                layOutItemViews()
            }
        }
    }
    public internal(set) var isWrapEnabled: Bool = false
    public var bounces: Bool = true
    internal var _scrollOffset: CGFloat = .zero
    public var scrollOffset: CGFloat {
        get { _scrollOffset }
        set { changeScrollOffset(newValue) }
    }
    public internal(set) var offsetMultiplier: CGFloat = 1.0
    public var contentOffset: CGSize = .zero {
        didSet {
            if contentOffset != oldValue {
                layOutItemViews()
            }
        }
    }
    public var viewpointOffset: CGSize = .zero {
        didSet {
            if viewpointOffset != oldValue {
                transformItemViews()
            }
        }
    }
    public internal(set) var numberOfItems: Int = 0
    public internal(set)var numberOfPlaceholders: Int = 0

    public internal(set) var numberOfVisibleItems: Int = 0
    public internal(set) var itemWidth: CGFloat = 0
    public internal(set) var toggle: CGFloat = 0
    public var autoscroll: CGFloat = 0 {
        didSet {
            if canAutoscroll {
                startAnimation()
            }
        }
    }
    internal var canAutoscroll: Bool {
        return autoscroll != 0
    }
    public var stopAtItemBoundary: Bool = true
    public var scrollToItemBoundary: Bool = true
    public var ignorePerpendicularSwipes: Bool = true
    public var centerItemWhenSelected: Bool = true

    public internal(set) var isDragging: Bool = false {
        didSet {
            if !isDragging && oldValue {
                if autoscroll > 0 {
                    state.tempOnePageValue = scrollOffset - scrollOffset.rounded(.towardZero)
                } else if autoscroll < 0 {
                    state.tempOnePageValue = scrollOffset.rounded(.towardZero) - scrollOffset
                }
            }
        }
    }
    public internal(set) var isDecelerating: Bool = false
    public internal(set) var isScrolling: Bool = false

    public let contentView: UIView
    
    public override init(frame: CGRect) {
        contentView = UIView(frame: CGRect(origin: .zero, size: frame.size))
        super.init(frame: frame)
        configInit()
    }
    
    required init?(coder: NSCoder) {
        contentView = UIView()
        super.init(coder: coder)
        configInit()
        contentView.frame = self.bounds
        if self.superview != nil {
            startAnimation()
        }
    }
    
    public func configInit() {
        self.addSubview(contentView)
        setupGesture()
        // set up accessibility
        self.accessibilityTraits = .allowsDirectInteraction
        self.isAccessibilityElement = true
        if dataSource != nil {
            reloadData()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        layOutItemViews()
    }
    
    public override func didMoveToSuperview() {
        if self.superview != nil {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    deinit {
        stopAnimation()
    }
}

extension iCarousel {
    func changeScrollOffset(_ newValue: CGFloat) {
        isScrolling = false
        isDecelerating = false
        state.startOffset = newValue
        state.endOffset = newValue
        if abs(newValue - _scrollOffset) > 0 {
            _scrollOffset = newValue
            depthSortViews()
            didScroll()
        }
    }
}
