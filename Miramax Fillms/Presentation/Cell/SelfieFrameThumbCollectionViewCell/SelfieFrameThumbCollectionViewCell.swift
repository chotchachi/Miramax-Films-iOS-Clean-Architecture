//
//  SelfieFrameThumbCollectionViewCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

class SelfieFrameThumbCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private var ivPreview: UIImageView!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // Container view
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white.withAlphaComponent(0.1)
        containerView.cornerRadius = 3.0
        containerView.borderWidth = 0.5
        containerView.borderColor = .white.withAlphaComponent(0.5)
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // Image view preview
        
        ivPreview = UIImageView()
        ivPreview.translatesAutoresizingMaskIntoConstraints = false
        ivPreview.contentMode = .scaleAspectFit
        ivPreview.clipsToBounds = true
        containerView.addSubview(ivPreview)
        ivPreview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.trailing.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(-3)
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
