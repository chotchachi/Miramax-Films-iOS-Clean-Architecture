//
//  UIScrollView+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit

extension UIScrollView {
    func scrollToTop() {
        setContentOffset(.zero, animated: true)
   }
}
