//
//  UIView+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 09/10/2022.
//

import UIKit

extension UIView {
    func superView<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superView(of: T.self) }
    }
}
