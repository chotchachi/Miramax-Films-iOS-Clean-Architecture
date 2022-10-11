//
//  EntertainmentResponseViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 08/10/2022.
//

import Domain

struct EntertainmentResponseViewModel {
    let page: Int
    let results: [EntertainmentViewModel]
    let totalPages: Int
    let totalResults: Int
}
