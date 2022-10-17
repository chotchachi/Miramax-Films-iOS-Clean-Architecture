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
    
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}
