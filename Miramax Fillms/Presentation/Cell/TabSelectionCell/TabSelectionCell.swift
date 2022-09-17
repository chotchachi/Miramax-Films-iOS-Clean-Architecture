//
//  TabSelectionCell.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import UIKit
import SnapKit

class TabSelectionCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private var tabLayout: TabLayout!
    
    // MARK: - Properties
    
    public weak var delegate: TabSelectionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        // tab layout
        
        tabLayout = TabLayout()
        tabLayout.translatesAutoresizingMaskIntoConstraints = false
        tabLayout.delegate = self
        
        // constraint layout
        
        contentView.addSubview(tabLayout)
        tabLayout.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24.0)
            make.trailing.equalToSuperview().offset(-24.0)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ titles: [String], selectIndex: Int) {
        tabLayout.titles = titles
        tabLayout.selectionTitle(index: selectIndex)
    }
}

// MARK: - TabLayoutDelegate

extension TabSelectionCell: TabLayoutDelegate {
    func didSelectAtIndex(_ index: Int) {
        delegate?.tabSelectionCell(onTabSelected: index)
    }
    
}
