//
//  DimensionConstants.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 20/09/2022.
//

import Foundation
import DeviceKit

struct DimensionConstants {
    static let appToolbarHeight: CGFloat = 55.0
    
    static let genreCellHeight: CGFloat = 48.0
    static let genreCellWidth: CGFloat = 100.0
        
    static let entertainmentHorizontalCellSpacing: CGFloat = 4.0
    static let entertainmentHorizontalCellRatio: CGFloat = 0.67
    
    static let entertainmentPreviewCellRatio: CGFloat = 1.5
    static let entertainmentPreviewCellSpacing: CGFloat = 16.0
    
    static let entertainmentDetailCellRatio: CGFloat = 0.55
    static let entertainmentDetailCellSpacing: CGFloat = 16.0

    static let personHorizontalCellSpacing: CGFloat = 16.0
    static let personHorizontalCellRatio: CGFloat = 0.65
    
    static let seasonSmallCellHeight: CGFloat = 80.0
    
    static let wishlistCellRatio: CGFloat = 0.55
    static let wishlistCellSpacing: CGFloat = 16.0
    
    static let movieCarouselItemViewRatio: CGFloat = 0.67
    
    static let entertainmentPreviewCollectionViewMinHeight: CGFloat = 500.0
    
    static var movieCarouselViewHeightConstraint: CGFloat {
        return Device.current.isPad ? 600.0 : 310.0
    }
    
    static var entertainmentHorizontalCollectionViewHeightConstraint: CGFloat {
        return Device.current.isPad ? 310.0 : 155.0
    }
    
    static var personHorizontalCollectionViewHeightConstraint: CGFloat {
        return Device.current.isPad ? 210.0 : 105.0
    }
    
    static var selfieFrameThumbCellRatio: CGFloat = 0.78
    static var selfieFrameThumbCellSpacing: CGFloat = 8.0
    
    static var recentlySelfieFrameHeightConstraint: CGFloat {
        return Device.current.isPad ? 250.0 : 190.0
    }
}
