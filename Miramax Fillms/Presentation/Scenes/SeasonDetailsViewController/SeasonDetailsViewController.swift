//
//  SeasonDetailsViewController.swift
//  Miramax Fillms
//
//  Created by Thanh Quang on 22/09/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class SeasonDetailsViewController: BaseViewController<SeasonDetailsViewModel> {

    // MARK: - Outlets + Views
    
    @IBOutlet weak var appToolbar: AppToolbar!
    @IBOutlet weak var tblEpisodes: UITableView!
    
    // MARK: - Properties
    
    private var popViewTriggerS = PublishRelay<Void>()
    private var episodeSelectTriggerS = PublishRelay<Episode>()
    
    override func configView() {
        super.configView()
        
        // Toolbar
        appToolbar.title = "episodes".localized
        appToolbar.rx.backButtonTap
            .bind(to: popViewTriggerS)
            .disposed(by: rx.disposeBag)
        
        // Seasons table view
        tblEpisodes.separatorStyle = .none
        tblEpisodes.register(cellWithClass: EpisodeCell.self)
        tblEpisodes.rx.modelSelected(Episode.self)
            .bind(to: episodeSelectTriggerS)
            .disposed(by: rx.disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = SeasonDetailsViewModel.Input(
            popViewTrigger: popViewTriggerS.asDriverOnErrorJustComplete(),
            episodeSelectTrigger: episodeSelectTriggerS.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Episode>> { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withClass: EpisodeCell.self)
            cell.bind(item)
            return cell
        }
        
        output.episodesData
            .map { [SectionModel(model: "", items: $0)] }
            .drive(tblEpisodes.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}
