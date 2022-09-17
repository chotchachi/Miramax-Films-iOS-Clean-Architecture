//
//  PrimaryButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import UIKit
import SwifterSwift

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        return desiredButtonSize
    }
    
    private func setup() {
        clipsToBounds = true
        setTitleColor(AppColors.colorAccent, for: .normal)
        titleLabel?.font = AppFonts.calloutSemiBold
        backgroundColor = .clear
        cornerRadius = 8.0
        borderColor = AppColors.colorAccent
        borderWidth = 1.0
        titleEdgeInsets = .init(top: 8.0, left: 24.0, bottom: 8.0, right: 24.0)
    }
}
