//
//  ItemCarouselView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 13/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift

class ItemCarouselView: UIView {
    
    // MARK: - View
    
    private var ivThumb: UIImageView!
    private var ivPlay: UIImageView!
    
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
        cornerRadius = 16.0
        borderColor = AppColors.colorAccent
        borderWidth = 1.0
        clipsToBounds = true
        
        // Image view thumb
        
        ivThumb = UIImageView()
        ivThumb.translatesAutoresizingMaskIntoConstraints = false
        ivThumb.contentMode = .scaleAspectFill
        addSubview(ivThumb)
        ivThumb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        // Image view play
        
        ivPlay = UIImageView()
        ivPlay.translatesAutoresizingMaskIntoConstraints = false
        ivPlay.image = UIImage(named: "ic_play_circle")
        addSubview(ivPlay)
        ivPlay.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
        }
    }
    
    func setImage(with imageURL: URL?) {
        ivThumb.setImage(with: imageURL)
    }
}
