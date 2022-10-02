//
//  SelfSizingCollectionView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 02/10/2022.
//

import UIKit

final class SelfSizingCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
