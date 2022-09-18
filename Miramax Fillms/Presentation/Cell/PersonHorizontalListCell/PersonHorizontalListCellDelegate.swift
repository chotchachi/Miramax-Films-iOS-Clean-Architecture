//
//  PersonHorizontalListCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

protocol PersonHorizontalListCellDelegate: AnyObject {
    func personHorizontalListRetryButtonTapped()
    func personHorizontalList(onItemTapped person: Person)
    func personHorizontalListSeeMoreButtonTapped()
}
