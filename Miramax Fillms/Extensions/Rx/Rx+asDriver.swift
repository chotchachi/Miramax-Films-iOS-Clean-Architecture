//
//  Rx+asDriver.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 15/09/2022.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}
