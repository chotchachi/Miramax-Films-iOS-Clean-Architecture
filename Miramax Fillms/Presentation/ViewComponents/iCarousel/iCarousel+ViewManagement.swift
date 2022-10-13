//
//  iCarousel+ViewManagement.swift
//  iCarouselSwift
//
//  Created by 郑军铎 on 2020/2/22.
//  Copyright © 2020 郑军铎. All rights reserved.
//

import Foundation
import UIKit
public extension iCarousel {
    var indexesForVisibleItems: [Int] {
        itemViews.keys.sorted()
    }
    var visibleItemViews: [UIView] {
        indexesForVisibleItems.map { itemViews[$0]! }
    }
    var currentItemView: UIView? {
        itemView(at: currentItemIndex)
    }
    func itemView(at index: Int) -> UIView? {
        itemViews[index]
    }
    func index(of itemView: UIView) -> Int? {
        itemViews.first(where: { $0.value == itemView })?.key
    }
    func indexOfItemViewOrSubview(_ view: UIView) -> Int? {
        if let index = self.index(of: view) {
            return index
        } else {
            if let superView = view.superview, view != contentView {
                return indexOfItemViewOrSubview(superView)
            }
        }
        return nil
    }
    func itemView(at point: CGPoint) -> UIView? {
        itemViews.values.compactMap {$0.itemCell}.sorted(by: compareViewDepth).last { (view) -> Bool in
            view.layer.hitTest(point) != nil
        }?.child
    }
}
extension iCarousel {
    func setItemView(_ itemView: UIView, forIndex index: Int) {
        itemViews[index] = itemView
    }
    func removeView(at index: Int) {
        self.itemViews = indexesForVisibleItems.reduce(into: [:], { (result, i) in
            if i < index {
                result[i] = itemViews[i]
            } else if i > index {
                result[i - 1] = itemViews[i]
            }
        })
    }
    func insert(_ itemView: UIView?, at index: Int) {
        self.itemViews = indexesForVisibleItems.reduce(into: [:], { (result, i) in
            if i < index {
                result[i] = itemViews[i]
            } else {
                result[i + 1] = itemViews[i]
            }
        })
        if let itemView = itemView {
            setItemView(itemView, forIndex: index)
        }
    }
}
