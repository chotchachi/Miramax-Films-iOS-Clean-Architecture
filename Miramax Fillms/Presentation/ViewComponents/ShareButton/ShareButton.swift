//
//  ShareButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import UIKit

final class ShareButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setImage(UIImage(named: "ic_toolbar_share"), for: .normal)
    }
}
