//
//  CircleImageView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 14/10/2022.
//

import UIKit

class CircleImageView: UIImageView {
    
    override public func layoutSubviews() {
        clipsToBounds = true
        layer.cornerRadius = self.layer.frame.height/2
    }
}
