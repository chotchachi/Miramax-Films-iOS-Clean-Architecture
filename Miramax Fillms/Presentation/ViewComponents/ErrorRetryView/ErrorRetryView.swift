//
//  ErrorRetryView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import RxSwift
import RxCocoa

final class ErrorRetryView: UIView, Displayable {
    
    // MARK: - Views
    
    fileprivate var lblErrorMessage: UILabel!
    fileprivate var btnRetry: PrimaryButton!
    
    // MARK: - Properties
    
    var isPresented: Bool = false
    
    var errorMessage: String? {
        didSet {
            guard let errorMessage = errorMessage else { return }
            lblErrorMessage.text = errorMessage
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in self.subviews {
            if view.isUserInteractionEnabled, view.point(inside: self.convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }
    
    private func setup() {
        lblErrorMessage = UILabel()
        lblErrorMessage.translatesAutoresizingMaskIntoConstraints = false
        lblErrorMessage.text = "an_error_occurred".localized
        lblErrorMessage.textColor = AppColors.textColorSecondary
        lblErrorMessage.font = AppFonts.caption1
        lblErrorMessage.textAlignment = .center
        addSubview(lblErrorMessage)
        lblErrorMessage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        btnRetry = PrimaryButton()
        btnRetry.titleText = "retry".localized
        addSubview(btnRetry)
        btnRetry.snp.makeConstraints { make in
            make.top.equalTo(lblErrorMessage.snp.bottom).offset(12.0)
            make.center.equalToSuperview()
        }
    }
    
    func resetState() {
        
    }
}

extension Reactive where Base: ErrorRetryView {
    var retryTapped: ControlEvent<Void> {
        return base.btnRetry.rx.tap
    }
}
