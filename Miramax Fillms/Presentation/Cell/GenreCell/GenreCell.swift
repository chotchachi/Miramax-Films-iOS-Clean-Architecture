//
//  GenreCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import UIKit
import SnapKit

class GenreCell: UICollectionViewCell {
    private var containerView: UIView!
    private var lblGenreName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(hex: 0x1A2138)
        containerView.layer.cornerRadius = 16.0
        containerView.layer.borderColor = UIColor(hex: 0x354271).cgColor
        containerView.layer.borderWidth = 1.0
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        lblGenreName = UILabel()
        lblGenreName.translatesAutoresizingMaskIntoConstraints = false
        lblGenreName.textColor = AppColors.textColorPrimary
        lblGenreName.font = AppFonts.medium(withSize: 14, dynamic: true)
        lblGenreName.textAlignment = .center
        lblGenreName.numberOfLines = 0
        lblGenreName.lineBreakMode = .byWordWrapping
        
        containerView.addSubview(lblGenreName)
        lblGenreName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8.0)
            make.leading.equalToSuperview().offset(8.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ genre: Genre) {
        lblGenreName.text = genre.name
    }
}
