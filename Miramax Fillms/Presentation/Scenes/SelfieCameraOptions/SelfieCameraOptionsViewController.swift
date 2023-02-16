//
//  SelfieCameraOptionsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 28/10/2022.
//

import UIKit
import SwifterSwift
import FSCalendar
import RxCocoa
import RxSwift
import SnapKit

typealias FormOptionsResult = (location: String?, date: Date?)

class SelfieCameraOptionsViewController: UIViewController {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tfSelectedLocation: UITextField!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var btnToggleCalendar: UIButton!
    @IBOutlet weak var selectedDateDividerView: UIView!
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    private var calendar: FSCalendar?
    
    @IBOutlet weak var btnDone: UIButton!
    
    // MARK: - Properties
    
    var onDoneAction: ((FormOptionsResult) -> Void)?
        
    var selectedLocation: String?
    var selectedDate: Date?
    
    private var currentPage: Date?
    private var calendarViewIsVisible = false

    private lazy var dateFormater: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d MMMM, yyyy"
        return dateFormater
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        updateCurrentSelectedDate(with: selectedDate)
        toggleCalendarView(visible: false)
    }
    
    private func configViews() {
        /// Main view
        mainView.roundCorners([.topLeft, .topRight], radius: 28.0)
        
        /// Label title
        lblTitle.text = "movie_selfie".localized
        lblTitle.textColor = AppColors.textColorPrimary
        lblTitle.font = AppFonts.bold(withSize: 20)
        
        /// Text field location
        tfSelectedLocation.placeholder = "enter_location".localized
        tfSelectedLocation.textColor = AppColors.textColorPrimary
        tfSelectedLocation.font = AppFonts.regular(withSize: 16)
        tfSelectedLocation.setPlaceHolderTextColor(AppColors.textColorSecondary)
        tfSelectedLocation.text = selectedLocation
        
        /// Label date
        lblSelectedDate.font = AppFonts.regular(withSize: 16)
        
        /// Button toggle calendar view
        btnToggleCalendar.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.calendarViewIsVisible.toggle()
                self.toggleCalendarView(visible: self.calendarViewIsVisible)
            })
            .disposed(by: rx.disposeBag)
        
        /// Button done
        btnDone.setTitle("done".localized, for: .normal)
        btnDone.setTitleColor(AppColors.textColorPrimary, for: .normal)
        btnDone.titleLabel?.font = AppFonts.semiBold(withSize: 16)
        btnDone.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.onDoneAction?((self.tfSelectedLocation.text, self.selectedDate))
                self.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction private func prevMonthButtonTapped() {
        moveCurrentPage(moveUp: false)
    }
    
    @IBAction private func nextMonthButtonTapped() {
        moveCurrentPage(moveUp: true)
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        currentPage = Calendar.current.date(byAdding: dateComponents, to: currentPage ?? Date())
        calendar?.setCurrentPage(currentPage!, animated: true)
    }
    
    private func updateCurrentSelectedDate(with date: Date?) {
        if let date = date {
            lblSelectedDate.text = dateFormater.string(from: date)
            lblSelectedDate.textColor = AppColors.textColorPrimary
        } else {
            lblSelectedDate.text = "select_date".localized
            lblSelectedDate.textColor = AppColors.textColorSecondary
        }
    }
    
    private func toggleCalendarView(visible: Bool) {
        calendarView.isHidden = !visible
        calendarViewHeightConstraint.constant = visible ? 320.0 : 0.0
        selectedDateDividerView.backgroundColor = visible ? AppColors.colorAccent : .white.withAlphaComponent(0.1)
        btnToggleCalendar.tintColor = visible ? .white : UIColor(hex: 0x242630)
        
        if visible {
            calendar = FSCalendar()
            calendar!.delegate = self
            calendar!.appearance.titleFont = AppFonts.caption1Medium
            calendar!.appearance.titleDefaultColor = .white
            calendar!.appearance.titlePlaceholderColor = .white.withAlphaComponent(0.5)
            calendar!.appearance.weekdayFont = AppFonts.bold(withSize: 10)
            calendar!.appearance.weekdayTextColor = UIColor(hex: 0x5F5F5F)
            calendar!.appearance.caseOptions = [.weekdayUsesUpperCase]
            calendar!.appearance.headerTitleFont = AppFonts.semiBold(withSize: 16)
            calendar!.appearance.headerTitleColor = .white
            calendar!.appearance.headerDateFormat = "MMMM yyyy"
            calendar!.appearance.headerMinimumDissolvedAlpha = 0
            calendar!.appearance.todayColor = .clear
            calendar!.appearance.selectionColor = AppColors.colorAccent
            calendar!.appearance.borderSelectionColor = UIColor(hex: 0xFF97A6)
            calendar!.select(selectedDate, scrollToDate: true)
            
            calendarView.insertSubview(calendar!, at: 0)
            calendar!.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            }
        } else {
            calendar?.removeFromSuperview()
            calendar = nil
        }
    }
}

// MARK: - FSCalendarDelegate

extension SelfieCameraOptionsViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        updateCurrentSelectedDate(with: date)
    }
}
