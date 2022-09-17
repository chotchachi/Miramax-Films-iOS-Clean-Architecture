//
//  TabLayout.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 17/09/2022.
//

import Foundation
import UIKit
import SnapKit

class TabLayout: UIView {
    
    // MARK: - Views
    
    private var indicator: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.cornerRadius = 1.5
        view.backgroundColor = AppColors.colorAccent
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = true
        view.isPagingEnabled = false
        view.isScrollEnabled = true
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .zero
        return view
    }()
    
    // MARK: - Properties
    
    var titles: [String] = [] {
        didSet {
            reloadView()
        }
    }
    
    weak var delegate: TabLayoutDelegate?
    private var titleLabels: [UILabel] = []
    
    var selectIndex = 0
    var normalTitleColor = AppColors.textColorPrimary.withAlphaComponent(0.5)
    var selectedTitleColor = AppColors.colorAccent
    var normalTitleFont = AppFonts.regular(withSize: 18)
    var selectedTitleFont = AppFonts.medium(withSize: 20)
    var indicatorWidth = 16.0
    var indicatorHeight = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
}

// MARK: - Public functions

extension TabLayout {
    public func selectionTitle(index: Int, animated: Bool = true) {
        if index >= 0 && index < titleLabels.count && selectIndex != index {
            
            let preSelectLabel = titleLabels[selectIndex]
            let selectLabel = titleLabels[index]
            let offsetX = min(max(0, selectLabel.center.x - bounds.width / 2),
                              max(0, scrollView.contentSize.width - bounds.width))
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

            moveSelectionIndicator(indicator, fromLabel: preSelectLabel, toLabel: selectLabel, animated: animated)
            
            selectIndex = index
            delegate?.didSelectAtIndex(index)
        }
    }
    
}

// MARK: - Private functions

extension TabLayout {
    private func setup() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSegmentTap))
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupTitleLabel(_ title: String, font: UIFont, index: Int, color: UIColor, frame: CGRect) {
        let titleLabel = UILabel()
        titleLabel.tag = index
        titleLabel.text = title
        titleLabel.textColor = color
        titleLabel.font = font
        titleLabel.frame = frame
        titleLabel.textAlignment = .center
        titleLabels.append(titleLabel)
        scrollView.addSubview(titleLabel)
    }
        
    private func reloadView() {
        titleLabels.removeAll()
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var font = normalTitleFont
        var titleColor = normalTitleColor
        
        for (i, title) in titles.enumerated() {
            let labelX = (titleLabels.last?.frame.maxX ?? 0)
            let labelY = (bounds.maxY - font.lineHeight) / 2
            let width = frame.width / CGFloat(titles.count)
            
            let labelFrame = CGRect(x: labelX, y: labelY, width: width, height: font.lineHeight)
            
            if i == selectIndex {
                titleColor = selectedTitleColor
                font = selectedTitleFont
                setupIndicator(labelFrame)
            } else {
                titleColor = normalTitleColor
                font = normalTitleFont
            }
            
            setupTitleLabel(title, font: font, index: i, color: titleColor, frame: labelFrame)
        }
        
        scrollView.contentSize.width = titleLabels.last?.frame.maxX ?? 0
    }
    
    private func setupIndicator(_ frame: CGRect) {
        indicator.frame = frame
        indicator.frame.size.width = indicatorWidth
        indicator.frame.origin.x = (frame.minX + frame.maxX) / 2 - (CGFloat(indicatorWidth) / 2)
        indicator.frame.origin.y = bounds.height - indicatorHeight
        indicator.frame.size.height = indicatorHeight
        
        scrollView.addSubview(indicator)
    }

    private func moveSelectionIndicator(_ indicator: UIView, fromLabel: UILabel, toLabel: UILabel, animated: Bool) {
        let sizeWidth = indicatorWidth
        let animationDuration = 0.15

        fromLabel.textColor = normalTitleColor
        toLabel.textColor = selectedTitleColor

        UIView.animate(withDuration: animationDuration) {
            fromLabel.font = self.normalTitleFont
            toLabel.font = self.selectedTitleFont
        }

        let fromeFrame = fromLabel.frame
        let toFrame = toLabel.frame

        if animated {
            if fromeFrame.origin.x < toFrame.origin.x {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveLinear, animations: {
                    indicator.frame.size.width = CGFloat(sizeWidth)
                }, completion: { (completion) in
                    UIView.animate(withDuration: animationDuration, animations: {
                        indicator.frame.size.width = CGFloat(sizeWidth)
                        indicator.frame.origin.x = toLabel.center.x - CGFloat(sizeWidth / 2)
                    })
                })

            } else {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveLinear, animations: {
                    indicator.frame.origin.x = toLabel.center.x - CGFloat(sizeWidth / 2)
                    indicator.frame.size.width = CGFloat(sizeWidth)
                }, completion: { (completion) in
                    UIView.animate(withDuration: animationDuration, animations: {
                        indicator.frame.size.width = CGFloat(sizeWidth)
                    })
                })
            }
        } else {
            indicator.frame.origin.x = toLabel.center.x - CGFloat(sizeWidth / 2)
            indicator.frame.size.width = CGFloat(sizeWidth)
        }
    }

    @objc private func handleSegmentTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tappedPointX = gestureRecognizer.location(in: self).x + scrollView.contentOffset.x
        for (i, label) in titleLabels.enumerated() {
            if tappedPointX >= label.frame.minX && tappedPointX <= label.frame.maxX {
                selectionTitle(index: i)
            }
        }
    }
}
