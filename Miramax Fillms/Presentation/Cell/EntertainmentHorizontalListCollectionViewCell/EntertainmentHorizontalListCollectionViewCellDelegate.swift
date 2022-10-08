//
//  EntertainmentHorizontalListCollectionViewCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

import Domain

protocol EntertainmentHorizontalListCollectionViewCellDelegate: AnyObject {
    func entertainmentHorizontalListRetryButtonTapped()
    func entertainmentHorizontalList(onItemTapped item: EntertainmentModelType)
    func entertainmentHorizontalListSeeMoreButtonTapped()
}
