//
//  BaseViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 12/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BaseViewController<T: BaseViewModel>: UIViewController {
    var viewModel: T!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        bindViewModel()
    }
    
    func configView() {
        setGradientBackground()
    }
    
    func bindViewModel() {
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .bind(to: viewModel.trigger)
            .disposed(by: rx.disposeBag)
    }
    
    private func setGradientBackground() {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.startColor = AppColors.colorPrimary
        gradientView.endColor = AppColors.colorSecondary
        view.insertSubview(gradientView, at: 0)
        gradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
