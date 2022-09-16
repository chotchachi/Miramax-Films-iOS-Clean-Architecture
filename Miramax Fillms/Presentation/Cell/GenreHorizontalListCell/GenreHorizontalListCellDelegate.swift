//
//  GenreHorizontalListCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

protocol GenreHorizontalListCellDelegate: AnyObject {
    func genreHorizontalListRetryButtonTapped()
    func genreHorizontalList(onItemTapped genre: Genre)
}
