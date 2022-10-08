//
//  EntertainmentHorizontalListCollectionViewCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Domain

protocol EntertainmentHorizontalListCollectionViewCellDelegate: AnyObject {
    func entertainmentHorizontalList(onItemTapped item: EntertainmentModelType)
    func entertainmentHorizontalList(onActionButtonTapped indexPath: IndexPath)
    func entertainmentHorizontalList(onRetryButtonTapped indexPath: IndexPath)
}
