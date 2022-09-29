//
//  ErrorRetryable.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 29/09/2022.
//

import Foundation
import UIKit

protocol ErrorRetryable: AnyObject {
    var errorRetryView: ErrorRetryView { get }
    func presentErrorRetryView(in view: UIView,
                               with errorMessage: String?)
    func hideErrorRetryView()
}

extension ErrorRetryable {
    func presentErrorRetryView(in view: UIView,
                               with errorMessage: String? = nil) {
        let isPresented = errorRetryView.isPresented
        if isPresented {
            errorRetryView.resetState()
        } else {
            errorRetryView.errorMessage = errorMessage
            errorRetryView.show(in: view, animated: true, completion: nil)
        }
    }
    
    func hideErrorRetryView() {
        errorRetryView.hide(animated: true, completion: nil)
    }
}

extension ErrorRetryable where Self: UIViewController {
    func presentErrorRetryView(with errorMessage: String? = nil) {
        presentErrorRetryView(in: self.view, with: errorMessage)
    }
}
