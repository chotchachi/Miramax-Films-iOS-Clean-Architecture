//
//  SortPopupView.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 05/10/2022.
//

import UIKit
import SnapKit
import SwifterSwift
import Domain

protocol SortPopupViewDelegate: AnyObject {
    func sortPopupView(onSortOptionSelect sortOption: SortOption)
}

final class SortPopupView: UIView {
    
    // MARK: - Views
    
    fileprivate var optionsStackView: UIStackView!
    
    // MARK: - Properties
    
    weak var delegate: SortPopupViewDelegate?
    
    private var sortOptions: [SortOption] = []
    
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
        translatesAutoresizingMaskIntoConstraints = false
        
        // Container view
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.cornerRadius = 8.0
        containerView.borderWidth = 1.0
        containerView.borderColor = AppColors.colorTertiary
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Visual effect view
        
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Options stack view
        
        optionsStackView = UIStackView()
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 0.0
        optionsStackView.alignment = .center
        containerView.addSubview(optionsStackView)
        optionsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-12.0)
            make.leading.equalToSuperview().offset(20.0)
            make.trailing.equalToSuperview().offset(-20.0)
        }        
    }
    
    func setSortOptions(_ options: [SortOption]) {
        sortOptions = options
        
        optionsStackView.removeArrangedSubviews()
        options.enumerated().forEach { (offset, item) in
            let optionButton = createOptionButton(sortOption: item, offset: offset)
            optionsStackView.addArrangedSubview(optionButton)
            optionButton.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(44.0)
            }
            if offset < options.count - 1 {
                let dividerView = createDividerView()
                optionsStackView.addArrangedSubview(dividerView)
                dividerView.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalTo(1.0)
                }
            }
        }
    }
    
    private func createOptionButton(sortOption: SortOption, offset: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = offset
        button.setTitle(sortOption.text, for: .normal)
        button.setTitleColor(AppColors.colorAccent, for: .selected)
        button.setTitleColor(AppColors.textColorPrimary, for: .normal)
        button.addTarget(self, action: #selector(sortOptionButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createDividerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.colorTertiary
        return view
    }
    
    @objc private func sortOptionButtonTapped(_ sender: UIButton) {
        let option = sortOptions[sender.tag]
        delegate?.sortPopupView(onSortOptionSelect: option)
    }
}
