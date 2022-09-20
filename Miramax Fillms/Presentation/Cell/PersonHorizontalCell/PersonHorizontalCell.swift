//
//  PersonHorizontalCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import SnapKit
import Kingfisher
import SwifterSwift

class PersonHorizontalCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPersonProfile: UIImageView!
    private var lblPersonName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // image view profile
        
        ivPersonProfile = UIImageView()
        ivPersonProfile.translatesAutoresizingMaskIntoConstraints = false
        ivPersonProfile.contentMode = .scaleAspectFill
        ivPersonProfile.clipsToBounds = true
        ivPersonProfile.kf.indicatorType = .activity
        
        // label name
        
        lblPersonName = UILabel()
        lblPersonName.translatesAutoresizingMaskIntoConstraints = false
        lblPersonName.font = AppFonts.caption1
        lblPersonName.textColor = AppColors.textColorPrimary
        lblPersonName.numberOfLines = 2
        lblPersonName.textAlignment = .center
        
        // constraint layout
        
        contentView.addSubview(ivPersonProfile)
        ivPersonProfile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(ivPersonProfile.snp.width)
        }
        
        contentView.addSubview(lblPersonName)
        lblPersonName.snp.makeConstraints { make in
            make.top.equalTo(ivPersonProfile.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivPersonProfile.cornerRadius = ivPersonProfile.width / 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ item: PersonModelType) {
        if let profileURL = item.personModelProfileURL {
            ivPersonProfile.kf.setImage(with: profileURL)
        }
        lblPersonName.text = item.personModelName
        
        layoutIfNeeded()
    }
}
