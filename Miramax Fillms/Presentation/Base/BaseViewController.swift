//
//  BaseViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit

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
        
    }
}
