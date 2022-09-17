//
//  BaseViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController<T: BaseViewModel>: UIViewController {
    var viewModel: T!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        bindViewModel()
    }
    
    func configView() {
        
    }
    
    func bindViewModel() {
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .bind(to: viewModel.trigger)
            .disposed(by: rx.disposeBag)        
    }
}
