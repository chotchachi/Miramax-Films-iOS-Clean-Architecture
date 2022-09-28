//
//  DefaultRefreshControl.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import UIKit

final class DefaultRefreshControl: UIRefreshControl {
    
    // MARK: - Properties
    
    private var refreshHandler: () -> Void
    
    // MARK: - Initializers
    
    init(title: String = "",
         refreshHandler: @escaping () -> Void) {
        self.refreshHandler = refreshHandler
        super.init()
        tintColor = UIColor.white
        backgroundColor = .clear
        attributedTitle = NSAttributedString(string: title,
                                             attributes: [NSAttributedString.Key.font: AppFonts.caption1SemiBold,
                                                          NSAttributedString.Key.foregroundColor: UIColor.white])
        addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc private func refreshControlAction() {
        refreshHandler()
    }
}
