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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // image view poster
        
        ivPersonProfile = UIImageView()
        ivPersonProfile.translatesAutoresizingMaskIntoConstraints = false
        ivPersonProfile.contentMode = .scaleAspectFill
        ivPersonProfile.clipsToBounds = true
        ivPersonProfile.kf.indicatorType = .activity
        
        // constraint layout
        
        contentView.addSubview(ivPersonProfile)
        ivPersonProfile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivPersonProfile.cornerRadius = ivPersonProfile.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ person: Person) {
        if let profileURL = person.profileURL {
            ivPersonProfile.kf.setImage(with: profileURL)
        }
    }
}
