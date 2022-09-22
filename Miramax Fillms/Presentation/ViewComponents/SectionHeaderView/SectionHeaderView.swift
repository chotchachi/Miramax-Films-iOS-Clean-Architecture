//
//  SectionHeaderView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SectionHeaderView: UIView {
    
    // MARK: - Views
    
    fileprivate var lblHeaderTitle: UILabel!
    fileprivate var btnSeeMore: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: SectionHeaderViewDelegate?
    
    @IBInspectable var title: String? {
        didSet {
            lblHeaderTitle.text = title
        }
    }
    
    @IBInspectable var showSeeMoreButton: Bool = true {
        didSet {
            btnSeeMore.isHidden = !showSeeMoreButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        setup()
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
    
    @objc private func seeMoreButtonTapped(_ sender: UIButton) {
        delegate?.sectionHeaderView(onSeeMoreButtonTapped: sender)
    }
}

extension Reactive where Base: SectionHeaderView {
    var seeMoreButtonTap: ControlEvent<Void> {
        return base.btnSeeMore.rx.tap
    }
}
