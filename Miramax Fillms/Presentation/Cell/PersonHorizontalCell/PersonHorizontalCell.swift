//
//  PersonHorizontalCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class PersonHorizontalCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivProfile: UIImageView!
    private var lblName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // image view profile
        
        ivProfile = UIImageView()
        ivProfile.translatesAutoresizingMaskIntoConstraints = false
        ivProfile.contentMode = .scaleAspectFill
        ivProfile.clipsToBounds = true
        
        // label name
        
        lblName = UILabel()
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblName.font = AppFonts.caption1
        lblName.textColor = AppColors.textColorPrimary
        lblName.numberOfLines = 2
        lblName.textAlignment = .center
        
        // constraint layout
        
        contentView.addSubview(ivProfile)
        ivProfile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(ivProfile.snp.width)
        }
        
        contentView.addSubview(lblName)
        lblName.snp.makeConstraints { make in
            make.top.equalTo(ivProfile.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivProfile.cornerRadius = ivProfile.width / 2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivProfile.cancelImageDownload()
        ivProfile.image = nil
    }
    
    func bind(_ item: PersonModelType) {
        ivProfile.setImage(with: item.personModelProfileURL)
        lblName.text = item.personModelName
        
        layoutIfNeeded()
    }
}
