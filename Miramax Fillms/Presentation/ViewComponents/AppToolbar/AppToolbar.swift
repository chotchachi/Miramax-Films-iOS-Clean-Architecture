//
//  AppToolbar.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit
import SwifterSwift

@IBDesignable
final class AppToolbar: UIView {

    // MARK: - Views
    
    private var btnBack: UIButton!
    private var lblTitle: UILabel!
    private var leftStackView: UIStackView!
    private var rightStackView: UIStackView!

    // MARK: - Properties
    
    weak var delegate: AppToolbarDelegate?
    
    @IBInspectable var title: String? {
        didSet {
            lblTitle.text = title
        }
    }
    
    @IBInspectable var showTitleLabel: Bool = true {
        didSet {
            lblTitle.isHidden = !showTitleLabel
        }
    }
    
    @IBInspectable var showBackButton: Bool = true {
        didSet {
            btnBack.isHidden = !showBackButton
        }
    }
    
    var rightButtons: [UIButton] = [] {
        didSet {
            updateRightStackView()
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
        btnBack = UIButton(type: .system)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.setImage(UIImage(named: "ic_navigation_back"), for: .normal)
        btnBack.tintColor = .white
        btnBack.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)

        lblTitle = UILabel()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.textColor = AppColors.textColorPrimary
        lblTitle.font = AppFonts.headlineBold

        leftStackView = UIStackView(arrangedSubviews: [btnBack, lblTitle], axis: .horizontal, spacing: 4.0, alignment: .center)
        rightStackView = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 16.0, alignment: .center)

        addSubview(leftStackView)
        leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
        }
        
        addSubview(rightStackView)
        rightStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
        }
        
        btnBack.snp.makeConstraints { make in
            make.height.equalTo(24.0)
            make.width.equalTo(24.0)
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        delegate?.appToolbar(onBackButtonTapped: sender)
    }
    
    private func updateRightStackView() {
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightStackView.addArrangedSubviews(rightButtons)
        
        rightButtons.forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(40.0)
                make.width.equalTo(40.0)
            }
        }
    }
}
