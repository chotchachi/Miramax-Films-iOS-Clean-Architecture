//
//  MovieHorizontalListCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

protocol MovieHorizontalListCellDelegate: AnyObject {
    func movieHorizontalListRetryButtonTapped()
    func movieHorizontalList(onItemTapped item: EntertainmentModelType)
    func movieHorizontalListSeeMoreButtonTapped()
}
