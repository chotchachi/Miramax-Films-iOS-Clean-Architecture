//
//  SettingViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 06/10/2022.
//

import UIKit
import RxCocoa
import RxSwift
import SwifterSwift
import MessageUI
import SafariServices

class SettingViewController: BaseViewController<SettingViewModel>, TabBarSelectable, Searchable {

    // MARK: - Outlets
    
    @IBOutlet weak var appToolbar: AppToolbar!
    
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var lblPolicy: UILabel!

    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var lblFeedback: UILabel!

    @IBOutlet weak var viewShareApp: UIView!
    @IBOutlet weak var lblShareApp: UILabel!

    var btnSearch: SearchButton = SearchButton()
    
    // MARK: - Properties
        
    // MARK: - Lifecycle
    
    override func configView() {
        super.configView()
     
        configureAppToolbar()
        configureOtherView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SettingViewModel.Input(
            toSearchTrigger: btnSearch.rx.tap.asDriver()
        )
        let _ = viewModel.transform(input: input)
    }
}

// MARK: - Private functions

extension SettingViewController {
    private func configureAppToolbar() {
        appToolbar.title = "setting".localized
        appToolbar.showBackButton = false
        appToolbar.rightButtons = [btnSearch]
    }
    
    private func configureOtherView() {
        [viewPolicy, viewFeedback, viewShareApp].forEach { view in
            view?.backgroundColor = UIColor(hex: 0x1A2138)
            view?.cornerRadius = 16.0
            view?.borderColor = UIColor(hex: 0x354271)
            view?.borderWidth = 1.0
            view?.shadowOffset = .init(width: 0.0, height: 1.0)
            view?.shadowRadius = 5.0
            view?.shadowOpacity = 0.4
            view?.shadowColor = .white.withAlphaComponent(0.4)
            view?.clipsToBounds = false
            view?.isUserInteractionEnabled = true
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionViewTapped(_:))))
        }
        
        lblPolicy.font = AppFonts.bodySemiBold
        lblPolicy.text = "policy".localized
        
        lblFeedback.font = AppFonts.bodySemiBold
        lblFeedback.text = "feedback".localized

        lblShareApp.font = AppFonts.bodySemiBold
        lblShareApp.text = "share_app".localized
    }
    
    @objc private func actionViewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        if view == viewPolicy {
            let safariVC = SFSafariViewController(url: URL(string: Constants.privacyLink)!)
            present(safariVC, animated: true, completion: nil)
        } else if view == viewFeedback {
            sendEmail()
        } else if view == viewShareApp {
            shareApp()
        }
    }
    
    private func sendEmail() {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        let subject = appName ?? "FeedBack"
        let body = ""
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Constants.emailFeedback])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: Constants.emailFeedback, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        }
        
        return defaultUrl
    }
    
    private func shareApp() {
        if let urlStr = NSURL(string: "https://apps.apple.com/app/id\(Constants.appId)") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UI_USER_INTERFACE_IDIOM() == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - TabBarSelectable

extension SettingViewController {
    func handleTabBarSelection() {
        
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
