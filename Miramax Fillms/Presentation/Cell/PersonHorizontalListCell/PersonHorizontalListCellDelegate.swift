//
//  PersonHorizontalListCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import Domain

protocol PersonHorizontalListCellDelegate: AnyObject {
    func personHorizontalList(onItemTapped item: Person)
    func personHorizontalList(onActionButtonTapped indexPath: IndexPath)
    func personHorizontalList(onRetryButtonTapped indexPath: IndexPath)
}
