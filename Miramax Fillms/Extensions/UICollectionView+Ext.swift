//
//  UICollectionView+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit

extension UICollectionView {
    func isScrolledToTop() -> Bool {
        return contentOffset == .zero
    }

    func scrollToTop(animated: Bool) {
        setContentOffset(.zero, animated: animated)
    }
}
