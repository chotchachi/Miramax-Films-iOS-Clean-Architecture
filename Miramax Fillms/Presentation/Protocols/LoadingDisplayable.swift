//
//  LoadingDisplayable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import UIKit

protocol LoadingDisplayable: AnyObject {
    var loaderView: LoadingView { get }
    func showLoader(in view: UIView)
    func hideLoader()
}

extension LoadingDisplayable {
    func showLoader(in view: UIView) {
        loaderView.show(in: view, animated: false, completion: nil)
        loaderView.startLoading()
    }
    
    func hideLoader() {
        loaderView.hide(animated: true, completion: { _ in
            self.loaderView.stopLoading()
        })
    }
}

extension LoadingDisplayable where Self: UIViewController {
    func showLoader() {
        showLoader(in: self.view)
    }
}
