//
//  IntrinsicTableView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import UIKit

class IntrinsicTableView: UITableView {
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
