//
//  SelfieWithMovieCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class SelfieWithMovieCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private var sectionHeaderView: SectionHeaderView!
    
    // MARK: - Properties
    
    public weak var delegate: SelfieWithMovieCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // section header view
        
        sectionHeaderView = SectionHeaderView()
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderView.title = "Selfie with movie"
        sectionHeaderView.showSeeMoreButton = false
        
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
        
        // camera image view
        
        let ivCameraIcon = UIImageView()
        ivCameraIcon.translatesAutoresizingMaskIntoConstraints = false
        ivCameraIcon.image = UIImage(named: "ic_camera_fill")
        ivCameraIcon.tintColor = .white
        
        // message label
        
        let lblMessage = UILabel()
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.text = "Take a picture with your \nfavorite movie"
        lblMessage.textColor = AppColors.textColorPrimary
        lblMessage.font = AppFonts.calloutMedium
        lblMessage.textAlignment = .center
        lblMessage.numberOfLines = 2
        
        // choose frame button
        
        let btnChooseFrame = PrimaryButton()
        btnChooseFrame.translatesAutoresizingMaskIntoConstraints = false
        btnChooseFrame.titleText = "Choose frame"
        btnChooseFrame.addTarget(self, action: #selector(selfieButtonTapped(_:)), for: .touchUpInside)
        
        // view wrapper
        
        let viewWrapper = UIStackView(arrangedSubviews: [ivCameraIcon, lblMessage, btnChooseFrame], axis: .vertical)
        viewWrapper.spacing = 8.0
        viewWrapper.alignment = .center
        
        // constraint layout
        
        contentView.addSubview(sectionHeaderView)
        sectionHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24.0)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeaderView.snp.bottom).offset(12.0)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
            make.leading.equalToSuperview().offset(16.0)
        }
        
        containerView.addSubview(viewWrapper)
        viewWrapper.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        ivCameraIcon.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.width.equalTo(40.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selfieButtonTapped(_ sender: UIButton) {
        delegate?.selfieWithMovieCellChooseFrameButtonTapped()
    }
}
