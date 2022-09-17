//
//  SectionHeaderView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit

final class SectionHeaderView: UIView {
    
    // MARK: - Views
    
    private var lblHeaderTitle: UILabel!
    private var btnSeeMore: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: SectionHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = AppColors.colorAccent
        dividerView.layer.cornerRadius = 1.5
        
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
            make.width.equalTo(3.0)
            make.height.equalTo(21.0)
        }
        
        lblHeaderTitle = UILabel()
        lblHeaderTitle.translatesAutoresizingMaskIntoConstraints = false
        lblHeaderTitle.font = AppFonts.subheadBold
        lblHeaderTitle.textColor = AppColors.textColorPrimary
        
        addSubview(lblHeaderTitle)
        lblHeaderTitle.snp.makeConstraints { make in
            make.leading.equalTo(dividerView.snp.trailing).offset(8.0)
            make.centerY.equalToSuperview()
        }
        
        btnSeeMore = UIButton(type: .system)
        btnSeeMore.setTitle("See more", for: .normal)
        btnSeeMore.setTitleColor(AppColors.colorAccent, for: .normal)
        btnSeeMore.titleLabel?.font = AppFonts.callout
        btnSeeMore.addTarget(self, action: #selector(seeMoreButtonTapped(_:)), for: .touchUpInside)
        
        addSubview(btnSeeMore)
        btnSeeMore.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
        }
    }
    
    public func setHeaderTitle(_ title: String) {
        lblHeaderTitle.text = title
    }
    
    @objc private func seeMoreButtonTapped(_ sender: UIButton) {
        delegate?.sectionHeaderView(onSeeMoreButtonTapped: sender)
    }
}
