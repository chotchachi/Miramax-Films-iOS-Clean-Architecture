//
//  BookmarkButton.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import UIKit

@IBDesignable
final class BookmarkButton: UIButton {
    
    // MARK: - Properties
    
    @IBInspectable var isBookmark: Bool = false {
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
        
        setBookmarkIcon()
    }
    
    private func setBookmarkIcon() {
        let icon = isBookmark ? UIImage(named: "ic_bookmark_fill") : UIImage(named: "ic_unbookmark_fill")
        setImage(icon, for: .normal)
    }
}
