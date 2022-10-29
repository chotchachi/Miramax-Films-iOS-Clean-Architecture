//
//  UIImage+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/10/2022.
//

import UIKit

extension UIImage {
    
    /**
     Suitable size for specific height or width to keep same image ratio
     */
    func suitableSize(heightLimit: CGFloat, widthLimit: CGFloat) -> CGSize {
        let imageRatio = self.size.height / self.size.width
        
        var height = self.size.height >= heightLimit ? heightLimit : self.size.height
        
        var width = height / imageRatio
        
        if width > widthLimit {
            width = widthLimit
            height = width * imageRatio
        }
        
        return .init(width: width, height: height)
    }
}
