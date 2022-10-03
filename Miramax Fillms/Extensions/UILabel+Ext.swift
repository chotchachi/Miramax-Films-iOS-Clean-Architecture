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
    
    func setText(_ text: String, before icon: UIImage?) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = icon
        // Set bound to reposition
        imageAttachment.bounds = CGRect(x: 0.0, y: -1.5, width: 12.0, height: 12.0)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add your text to mutable string
        let textBeforeIcon = NSAttributedString(string: text)
        completeText.append(textBeforeIcon)
        // Add image to mutable string
        completeText.append(attachmentString)
        attributedText = completeText
    }
}
