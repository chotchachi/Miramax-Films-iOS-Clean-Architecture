//
//  UILabel+Ext.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import UIKit

extension UILabel {
    func highlight(text: String?, font: UIFont? = nil, color: UIColor? = nil) {
        guard let fullText = self.text, let target = text else {
            return
        }

        let attribText = NSMutableAttributedString(string: fullText)
        let range: NSRange = attribText.mutableString.range(of: target, options: .caseInsensitive)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let color = color {
            attributes[.foregroundColor] = color
        }
        attribText.addAttributes(attributes, range: range)
        self.attributedText = attribText
    }
}
