//
//  SelfieWithMovieView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 02/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import RxSwift
import RxCocoa

final class SelfieWithMovieView: UIView {
    
    // MARK: - Views
    
    fileprivate var btnAction: PrimaryButton!
        
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
        backgroundColor = .clear
        
        // main container
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.cornerRadius = 16.0
        containerView.shadowColor = UIColor.black.withAlphaComponent(0.2)
        containerView.shadowOffset = .init(width: 0.0, height: 2.0)
        containerView.shadowRadius = 10.0
        containerView.shadowOpacity = 1.0
        containerView.layer.masksToBounds = false
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
            make.leading.equalToSuperview().offset(16.0)
        }
        
        // camera image view
        
        let ivCameraIcon = UIImageView()
        ivCameraIcon.translatesAutoresizingMaskIntoConstraints = false
        ivCameraIcon.image = UIImage(named: "ic_camera_fill")
        ivCameraIcon.tintColor = .white
        
        // message label
        
        let lblMessage = UILabel()
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.text = "selfie_with_movie_title".localized
        lblMessage.textColor = AppColors.textColorPrimary
        lblMessage.font = AppFonts.caption1Medium
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 2
        
        // choose frame button
        
        btnAction = PrimaryButton()
        btnAction.translatesAutoresizingMaskIntoConstraints = false
        btnAction.titleText = "selfie_with_movie_action_button_title".localized
        
        // view wrapper
        
        let viewWrapper = UIStackView(arrangedSubviews: [ivCameraIcon, lblMessage, btnAction], axis: .vertical)
        viewWrapper.spacing = 8.0
        viewWrapper.alignment = .center
        
        containerView.addSubview(viewWrapper)
        viewWrapper.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        ivCameraIcon.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.width.equalTo(40.0)
        }
    }
}

extension Reactive where Base: SelfieWithMovieView {
    var actionTapped: ControlEvent<Void> {
        return base.btnAction.rx.tap
    }
}
