//
//  ColumnFlowLayout.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 27/09/2022.
//

import Foundation
import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    let cellsPerRow: Int
    let ratio: CGFloat
    
    init(cellsPerRow: Int,
         ratio: CGFloat,
         minimumInteritemSpacing: CGFloat = 0,
         minimumLineSpacing: CGFloat = 0,
         sectionInset: UIEdgeInsets = .zero,
         scrollDirection: UICollectionView.ScrollDirection
    ) {
        self.cellsPerRow = cellsPerRow
        self.ratio = ratio
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.scrollDirection = scrollDirection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        if scrollDirection == .vertical {
            let marginsAndInsets = sectionInset.left
            + sectionInset.right
            + collectionView.safeAreaInsets.left
            + collectionView.safeAreaInsets.right
            + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            let itemHeight = itemWidth * ratio
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
        } else {
            let marginsAndInsets = sectionInset.top
            + sectionInset.bottom
            + collectionView.safeAreaInsets.top
            + collectionView.safeAreaInsets.bottom
            + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            
            let itemHeight = ((collectionView.bounds.size.height - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            let itemWidth = itemHeight * ratio
            
            itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
