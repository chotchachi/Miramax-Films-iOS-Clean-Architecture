//
//  PMAlertAction.swift
//  PMAlertController
//
//  Created by Paolo Musolino on 07/05/16.
//  Copyright © 2018 Codeido. All rights reserved.
//

import UIKit

public enum PMAlertActionStyle: Int {
    case `default`
    case cancel
}

open class PMAlertAction: UIButton {
    
    fileprivate var action: (() -> Void)?
    
    open var actionStyle: PMAlertActionStyle
    
    open var separator = UIImageView()
    
    init() {
        self.actionStyle = .cancel
        super.init(frame: CGRect.zero)
    }
    
    public convenience init(title: String?, style: PMAlertActionStyle, action: (() -> Void)? = nil) {
        self.init()
        
        self.action = action
        
        addTarget(self, action: #selector(PMAlertAction.tapped(_:)), for: .touchUpInside)
        
        setTitle(title, for: UIControl.State())
        titleLabel?.font = AppFonts.bodySemiBold
        
        actionStyle = style
        
        let titleColor = style == .default ? AppColors.colorAccent : AppColors.colorTertiary
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
        
        addSeparator()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func tapped(_ sender: PMAlertAction) {
        // Action need to be fired after alert dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.action?()
        }
    }
    
    fileprivate func addSeparator() {
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addSubview(separator)
        
        // Autolayout separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
