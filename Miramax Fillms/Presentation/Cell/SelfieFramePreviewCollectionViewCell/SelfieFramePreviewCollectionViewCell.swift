//
//  SelfieFramePreviewCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class SelfieFramePreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPreview: UIImageView!
    private var btnApply: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Image view preview
        
        ivPreview = UIImageView()
        ivPreview.translatesAutoresizingMaskIntoConstraints = false
        ivPreview.contentMode = .scaleAspectFill
        ivPreview.clipsToBounds = true
        contentView.addSubview(ivPreview)
        ivPreview.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // Button apply
        
        btnApply = UIButton(type: .system)
        btnApply.translatesAutoresizingMaskIntoConstraints = false
        btnApply.cornerRadius = 16.0
        btnApply.backgroundColor = AppColors.colorTertiary
        btnApply.setImage(UIImage(named: "ic_circle_check"), for: .normal)
        btnApply.setTitle("apply".localized, for: .normal)
        btnApply.setTitleColor(AppColors.textColorPrimary, for: .normal)
        btnApply.titleLabel?.font = AppFonts.caption2
        btnApply.tintColor = AppColors.textColorPrimary
        btnApply.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6.0)
        contentView.addSubview(btnApply)
        btnApply.snp.makeConstraints { make in
            make.top.equalTo(ivPreview.snp.bottom).offset(6.0)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(32.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ivPreview.cancelImageDownload()
        ivPreview.image = nil
    }
    
    func bind(_ item: SelfieFrame) {
        ivPreview.setImage(with: item.previewURL)
    }
}
