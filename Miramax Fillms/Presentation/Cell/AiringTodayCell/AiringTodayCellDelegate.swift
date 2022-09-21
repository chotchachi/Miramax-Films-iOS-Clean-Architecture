//
//  AiringTodayCellDelegate.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 21/09/2022.
//

import Foundation

protocol AiringTodayCellDelegate: AnyObject {
    func airingTodayCell(didTapPlayButton item: EntertainmentModelType)
    func airingTodayCellRetryButtonTapped()
}