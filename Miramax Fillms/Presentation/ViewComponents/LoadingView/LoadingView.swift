//
//  LoadingView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

final class LoadingView: UIView, Displayable {
    
    // MARK: - Views
    
    fileprivate var loadingIndicator: UIActivityIndicatorView!
    fileprivate var lblLoadingMessage: UILabel!
    
    // MARK: - Properties
    
    var isPresented: Bool = false
    
    var loadingMessage: String? {
        didSet {
            guard let loadingMessage = loadingMessage else { return }
            lblLoadingMessage.text = loadingMessage
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
    
    private func setup() {
        isUserInteractionEnabled = false
        
        if #available(iOS 13.0, *) {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .white)
        }
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        lblLoadingMessage = UILabel()
        lblLoadingMessage.translatesAutoresizingMaskIntoConstraints = false
        lblLoadingMessage.text = "loading".localized
        lblLoadingMessage.textColor = AppColors.textColorSecondary
        lblLoadingMessage.font = AppFonts.caption1
        lblLoadingMessage.textAlignment = .center
        addSubview(lblLoadingMessage)
        lblLoadingMessage.snp.makeConstraints { make in
            make.top.equalTo(loadingIndicator.snp.bottom).offset(12.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
}
