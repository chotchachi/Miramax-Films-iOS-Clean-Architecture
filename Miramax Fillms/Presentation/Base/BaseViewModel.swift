//
//  BaseViewModel.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import RxSwift
import RxCocoa

class BaseViewModel: NSObject {
    let trigger = PublishRelay<Void>()
    let loading = ActivityTracker()
    let error = ErrorTracker()
    
    deinit {
        print("\(self): Deinited")
    }
}
