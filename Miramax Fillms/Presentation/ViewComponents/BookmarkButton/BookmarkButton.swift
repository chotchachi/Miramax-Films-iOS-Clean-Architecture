//
//  BookmarkButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
final class BookmarkButton: UIButton {
    
    // MARK: - Properties
    
    @IBInspectable var isBookmark: Bool = false {
        didSet {
            setBookmarkIcon()
        }
    }
    
    @IBInspectable var unbookmarkBlackTint: Bool = false {
        didSet {
            setBookmarkIcon()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 36.0, height: 36.0)
    }
    
    override func prepareForInterfaceBuilder() {
        invalidateIntrinsicContentSize()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitle("", for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setBookmarkIcon()
    }
    
    private func setBookmarkIcon() {
        let icon = isBookmark
        ? UIImage(named: "ic_bookmark_fill")
        : (unbookmarkBlackTint ? UIImage(named: "ic_unbookmark_fill_black") : UIImage(named: "ic_unbookmark_fill_white"))
        setImage(icon, for: .normal)
    }
    
    @objc private func buttonTapped() {
        isBookmark.toggle()
        sendActions(for: .valueChanged)
    }
}

extension Reactive where Base: BookmarkButton {
    var isBookmark: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { view in
                return view.isBookmark
            },
            setter: { (view, newValue) in
                view.isBookmark = newValue
            }
        )
    }
}
