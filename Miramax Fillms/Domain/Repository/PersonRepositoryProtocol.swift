//
//  PersonRepositoryProtocol.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 18/09/2022.
//

import RxSwift

protocol PersonRepositoryProtocol {
    func getPersonDetail(personId: Int) -> Single<PersonDetail>
}
