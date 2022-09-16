//
//  PrimaryButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import UIKit

@IBDesignable
final class PrimaryButton: UIButton {
    
    @IBInspectable var titleText: String? {
        didSet {
            setTitle(titleText, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    func setup() {
        clipsToBounds = true
        layer.cornerRadius = 4.0
        backgroundColor = .red
        setTitleColor(.white, for: .normal)
    }
}
