//
//  SeasonsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class SeasonsViewController: BaseViewController<SeasonsViewModel> {
    
    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tblSeasons: UITableView!
    
    // MARK: - Properties
    
    private let popViewTriggerS = PublishRelay<Void>()
    private let seasonSelectTriggerS = PublishRelay<Season>()

    override func configView() {
        super.configView()
        
        // Toolbar
        appToolbar.title = "seasons".localized
        appToolbar.rx.backButtonTap
            .bind(to: popViewTriggerS)
            .disposed(by: rx.disposeBag)
        
        // Seasons table view
        tblSeasons.separatorStyle = .none
        tblSeasons.register(cellWithClass: SeasonLargeCell.self)
        tblSeasons.rx.modelSelected(Season.self)
            .bind(to: seasonSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SeasonsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            seasonSelectTrigger: seasonSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Season>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: SeasonLargeCell.self)
            cell.bind(item)
            return cell
        }
        
        output.seasonsData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tblSeasons.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}