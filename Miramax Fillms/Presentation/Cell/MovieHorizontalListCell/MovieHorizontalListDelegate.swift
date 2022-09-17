//
//  MovieHorizontalListDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 16/09/2022.
//

protocol MovieHorizontalListDelegate: AnyObject {
    func movieHorizontalListRetryButtonTapped()
    func movieHorizontalList(onItemTapped movie: Movie)
    func movieHorizontalListSeeMoreButtonTapped()
}
