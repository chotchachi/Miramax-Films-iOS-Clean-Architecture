//
//  PrimaryButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import UIKit
import SwifterSwift

fileprivate let kNormalColor: UIColor = AppColors.colorAccent
fileprivate let kHighlightColor: UIColor = AppColors.colorAccent.withAlphaComponent(0.5)

@IBDesignable
final class PrimaryButton: UIButton {
    
    @IBInspectable var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        return desiredButtonSize
    }
    
    override var isHighlighted: Bool {
        didSet {
            borderColor = isHighlighted ? kHighlightColor : kNormalColor
        }
    }
    
    private func setup() {
        clipsToBounds = true
        setTitleColor(kNormalColor, for: .normal)
        setTitleColor(kHighlightColor, for: .highlighted)
        titleLabel?.font = AppFonts.caption1SemiBold
        backgroundColor = .clear
        cornerRadius = 8.0
        borderWidth = 1.0
        borderColor = kNormalColor
        titleEdgeInsets = .init(top: 8.0, left: 24.0, bottom: 8.0, right: 24.0)
    }
}
